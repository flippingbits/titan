Titan
======

Titan helps you creating daemon threads, that can be accessed later on. On the one side it creates daemons that run in the background and don't stop if the current process exits. On the other
side it manages created daemon threads and provides a possibility to access them later on by a custom id.

Usage
======

Creating a new daemon thread using Titan is pretty easy:

  Titan::Thread.new do
    # here comes the programm
    sleep(15)
    puts "I'm awake!"
  end

Furthermore you can pass an id to each created thread that can be used for identification later on:

  Titan::Thread.new(:id => "my_new_thread") do
    sleep(15)
    puts "I'm awake!"
  end

The identifier must be unique.

If you want to access the thread in the future Titan::Manager is the tool of your choice:

  Titan::Thread.new(:id => "my_new_thread") do
    sleep(15)
    puts "I'm awake!"
  end
  manager = Titan::Manager.new
  manager.attach(thread)

It manages threads and saves them in a special .titan file that can be found in your home folder.

You can easily list all available threads:

  manager = Titan::Manager.new
  manager.all

By using the manager you can kill currently running threads:

  manager = Titan::Manager.new
  manager.kill(manager.find("my_new_thread"))

Note on Patches/Pull Requests
======

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
======

Copyright (c) 2010 Stefan Sprenger. See LICENSE for details.
