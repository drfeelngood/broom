Broom
=====
	A simple module to help monitor a directory for new files and perform an action
on each new file.  Broom periodically sweeps a directory, caching each file and its 
last modification time.  After each sweep, Broom iterates through the cache and 
yields only the files that have a current modification time that matches the cached 
modification time.  In the event of an error, Broom gracefully sweeps
the file to a failure dustpan.  Else, the file is swept to a success dustpan.

	Broom depends on the following directory structure, which can be modified
using the 'success_dir' and 'failure_dir' options.

	/path/to/directory
	/path/to/directory/_success
	/path/to/directory/_failure
	
Examples
========

	Broom.sweep('/tmp', :pattern => '*.pdf') do |file|
		Resque.enqueue(Job, file)
	end