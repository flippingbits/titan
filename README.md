Titan
======

Titan helps you creating daemon threads, that can be accessed later on. On the one side it creates daemons that run in the background and don't stop if the current process exits. On the other
side it manages created daemon threads and provides functionality for accessing them later on by a custom id.

Usage
======

First, you've to install the gem:

    gem install titan

Creating a new daemon thread using Titan is pretty easy:

    Titan::Thread.new do
      # here comes the programm
      sleep(15)
      puts "I'm awake!"
    end

Furthermore you can pass an id to each created thread that can be used for identification in the future:

    Titan::Thread.new(:id => "my_new_thread") do
      sleep(15)
      puts "I'm awake!"
    end

It's also possible to change the identifier after creation:

    thread = Titan::Thread.new do
      1+1
    end
    thread.id = "my_new_thread"

The identifier must be unique.

If you want to access the thread in the future, Titan::Manager is the tool of your choice:

    thread = Titan::Thread.new(:id => "my_new_thread") do
      sleep(15)
      puts "I'm awake!"
    end
    Titan::Manager.add(thread)

It manages threads and saves them in a special .titan file that can be found in your home folder.

You can easily list all available threads:

    Titan::Manager.all_threads

By using the manager you can find currently running threads using their identifier:

    thread  = Titan::Manager.find("my_new_thread")

A thread can be forced to exit:

    thread.kill if thread.alive?

If you want to remove threads from the manager, that aren't running any longer, you can do this by:

    Titan::Manager.remove_dead_threads

Furthermore, you can check if a single thread is alive:

    thread = Titan::Manager.find("my_new_thread")
    thread.alive? # returns true or false

Requirements
======

* Linux or Mac OS X

Bugs
======

Please report bugs at http://github.com/flippingbits/titan/issues.

Note on Patches/Pull Requests
======

* Fork the project from http://github.com/flippingbits/titan.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
======

Copyright (c) 2010 Stefan Sprenger. See LICENSE for details.
