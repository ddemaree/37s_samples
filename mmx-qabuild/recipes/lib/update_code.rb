task :update_code do
  current_branch, branch_present = '', false
  run("cd #{current_path}; git branch | awk 'NF > 1' | awk '{if ($1 = \"*\") print $2}'") do |c, s, data|
    current_branch = data.strip
  end

  target_branch = fetch(:target_branch, ENV['branch']) || current_branch
  logger.trace( "Target: #{target_branch}" )

  commands = ["cd #{current_path}"]

  if current_branch != target_branch
    logger.trace( "Switching branches from #{current_branch} to #{target_branch}" )

    commands << "git fetch origin"

    run("cd #{deploy_to}; git branch | grep '\\<#{target_branch}\\>' | wc -l") do |ch, stream, data|
      branch_present = !data.to_i.zero?
    end

    if !branch_present
      commands << "git branch #{target_branch} origin/#{target_branch}"
    end

    commands << "git checkout #{target_branch}"
  else
    commands << "git pull origin #{target_branch}"
  end

  commands << "git reset --hard"

  run commands.join("; ")
end