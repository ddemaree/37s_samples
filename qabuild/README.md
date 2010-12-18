# Metromix QA Build Tools #

This gem exists to provide a much simplified Capistrano build interface so that our QA team can update code on any of our four testing environments with an easy-to-use command line interface. This code has performed that job almost flawlessly, and shortly after it entered daily use our head of QA nominated me for a "MOE" (Metromix Outstanding Employee) award for making her work easier.

This gem installs a single command line tool called `qabuild`. `qabuild` takes one of three commands:

    Usage: qabuild COMMAND [ARGS]

    Commands:
     status    Fetches and shows current branch status for all qa environments
     change    Change the branch being used for the given qa environment
     rebuild   Rebuilds the current branch for the given qa environment
     
The `status` command uses the `MMX::Builder::Inquirer` class (which in turn uses `Net::SSH`) to remotely query each of our five projects on each QA server and report back what their `git describe` output is, with the latest tag name and commit hash.

The other two deploy the code. `rebuild` performs a hard Git reset to `origin/WHATEVER_THE_CURRENT_BRANCH_IS`; `change` pulls and checks out a specified branch.

I include this here because I feel `qabuild` is a great, if wonkish, example of building simple software that fills a genuine need. This tool paves cowpaths we were already using many times a day, and so allowed us to spend less time fighting with our servers and more time writing and testing code.