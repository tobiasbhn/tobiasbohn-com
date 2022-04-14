namespace :db do

  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      exit 1
    else
      exit 0
    end
  end

  # Databse dump and load from
  # https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90

  # Examples

  # [docker-compose run web] rake db:dump
  # => dumps database to ./db/backups/20220308151637_db_backup.psql

  # [docker-compose run web] rake db:dump .
  # => dumps database to ./20220308151637_db_backup.psql
  desc "Dumps the database to backups"
  task :dump => :environment do
    cmd, cmd_pw = nil
    path = ARGV[1]&.to_s
    path ||= "#{Rails.root}/db/backups"
    with_config do |app, host, db, user, pw|
      cmd = "pg_dump -F c -v -O -x -U '#{user}' -h '#{host}' -d '#{db}' -f '#{path}/#{Time.now.strftime("%Y%m%d%H%M%S")}_db_backup.psql'"
      cmd_pw = "PGPASSWORD=\"#{pw}\" #{cmd}"
    end
    puts cmd
    exec cmd_pw
  end

  # Examples

  # [docker-compose run web] rake db:restore default .
  # => restores database from dump ./default_db_backup.psql
  # ./default_db_backup.psql is only the backup included in git and contains initial content

  # [docker-compose run web] rake db:restore
  # => Please pass a name to the task

  # [docker-compose run web] rake db:restore 20220308151637
  # => restores database from dump ./db/backups/20220308151637_db_backup.psql

  # for production (production wont let you drop database) !! WILL DROP DATABASE !!
  # [docker-compose run web] rake db:restore default . DISABLE_DATABASE_ENVIRONMENT_CHECK=1
  desc "Restores the database from backups"
  task :restore => :environment do
    name = ARGV[1]&.to_s
    if name.present?
      path = ARGV[2]&.to_s
      path ||= "#{Rails.root}/db/backups"

      cmd, cmd_pw = nil
      with_config do |app, host, db, user, pw|
        cmd = "pg_restore -F c -v -O -x -U '#{user}' -h '#{host}' -d '#{db}' '#{path}/#{name}_db_backup.psql'"
        cmd_pw = "PGPASSWORD=\"#{pw}\" #{cmd}"
      end
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      puts cmd
      exec cmd_pw
      Rake::Task["db:environment:set", "RAILS_ENV=#{environment.to_s}"]
    else
      puts 'Please pass a name to the task'
    end
  end

  # Workflow mirroring Prod Environemt:
  # 1. run db:dump on production server
  # 2. transver .psql file to target environment (dev or stage or whatever)
  # 3. run db:restore on target environment to achive mirror of live page
  # images from active stroage are not included (as not saved in db)

  # Workflow Init new Prod/Stage Environment
  # 1. run "docker-compose run web rake db:restore default . DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
  #    to load default content included in Docker-Image

  private

  def with_config
      yield Rails.application.class.module_parent_name.underscore,
      ActiveRecord::Base.connection_db_config.configuration_hash[:host],
      ActiveRecord::Base.connection_db_config.configuration_hash[:database],
      ActiveRecord::Base.connection_db_config.configuration_hash[:username],
      ActiveRecord::Base.connection_db_config.configuration_hash[:password]
  end

end
