# Dynamically creates multistage-style tasks and roles for
# each of the four QA environments. By convention, SSH hostnames
# include zeros (mxxqa04.mmx.local) but are web-accessible without
# them (chicago.qa4.mmx.local)

%w(1 2 3 4).each do |env_num|
  desc "Set environment to qa0#{env_num}"
  task("qa0#{env_num}".to_sym) do
    set  :qa_env, "qa#{env_num}"
    role :app, "mxxqa0#{env_num}.mmx.local"
  end
end

