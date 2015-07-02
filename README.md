# Capistrano::TransferProgress

Hooks on capistrano transfers and provides a callback that displays a progressbar with current transfer progress.

Can handle:
* Simultaneous transfers
* SCP and SFTP
* Multiple files (recursive)
* Uploads & Downloads

Cannot handle:
* SFTP Downloads as they do not report the total file size

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-transfer_progress'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-transfer_progress

## Usage

Add this line to your application's Capfile:

    require 'capistrano-transfer_progress'

That's it!  
You can now see progress bars on your capistrano transfers looking like this:

    Transfering:    64% |ooooooooooooo       | ETA:   0:02:11

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
