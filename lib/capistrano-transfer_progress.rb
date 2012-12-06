require "capistrano-transfer_progress/version"

require 'progressbar'

module Capistrano
  # Hooks on capistrano transfers and provides a callback that displays a progressbar with current transfer progress
  #
  # Can handle:
  # * Simultaneous transfers
  # * SCP and SFTP
  # * Multiple files (recursive)
  # * Uploads & Downloads
  #
  # Cannot handle:
  # * SFTP Downloads as they do not report the total file size
  module TransferProgress
    def transfer(*args)
      if block_given?
        super(*args)
      else
        # Here we hook the tracking on our own by default if no progress block given to the transfer method
        super(*args) { |*a| track(*a) }
      end
    end

    # Tracks SCP or SFTP tranfer progress
    def track(*args)
      if args[0].is_a?(Symbol) && args[1].is_a?(Net::SFTP::Operations::Upload)
        track_sftp_transfer(*args)
      elsif args[0].is_a?(Net::SSH::Connection::Channel)
        track_scp_transfer(*args)
      end
    end

    #######
    private
    #######

    def track_sftp_transfer(event, options, *others)
      key = "#{options.class}-#{options.sftp.object_id}:#{others[0].local}:#{others[0].remote}" if [:open, :put, :close].include? event

      case event
        when :open
          update_session key, 0, others[0].size
        when :put
          update_session key, others[1]
        when :close
          end_session key
      end
    end

    def track_scp_transfer(channel, name, sent, total)
      update_session("#{channel.class}-#{channel.object_id}:#{name}", sent, total)
    end

    def update_session(key, sent, total = nil)
      @bar ||= ProgressBar.new("Transfering", 1)

      @active_sessions ||= {}
      @active_sessions[key] ||= {}
      @active_sessions[key].merge!(:sent => sent)

      unless total.nil?
        @active_sessions[key].merge!(:total => total)
        update_bar_total
      end

      update_bar_progress

      end_session(key) if sent == total
    end

    def end_session(key)
      @active_sessions.delete key
      update_bar_total
      update_bar_progress
      if @active_sessions.empty?
        @bar.finish
        @bar = nil
      end
    end

    def update_bar_total
      new_total = @active_sessions.inject(0) { |sum, (k, v)| sum + v[:total] }
      @bar.instance_eval { @total = new_total }
    end

    def update_bar_progress
      @bar.set @active_sessions.inject(0) { |sum, (k, v)| sum + v[:sent] }
    end
  end
end

# Inject transfer progress tracking in current capistrano configuration instance
class Capistrano::Configuration
  include Capistrano::TransferProgress
end
