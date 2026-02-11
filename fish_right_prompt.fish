set -g _pad " "

## Function to show a segment
function prompt_segment -d "Function to show a segment"
  # Get colors
  set -l bg $argv[1]
  set -l fg $argv[2]

  # Set 'em
  set_color -b $bg
  set_color $fg

  # Print text
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3]
  end
end

## Function to show current status
function show_status -d "Function to show the current status"

  # Print last exit code if nonzero:
  if [ $RETVAL -ne 0 ]
    prompt_segment normal red (set_color --bold red)
    printf '%d' $RETVAL
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end

function _git_status
  set -q fish_prompt_git_timeout; or set fish_prompt_git_timeout 0.3
  set -l _git_status (timeout $fish_prompt_git_timeout git status --porcelain 2> /dev/null)
  set -l _git_status_output $status
  # printf '%s' $_git_status_output
  if test $_git_status_output -eq 124 -o $_git_status_output -eq 138
    echo 'unknown'
    return
  end
  set -l _git_status $_git_status | string collect
  if test -n "$_git_status"
    if echo $_git_status | grep '^.[^ ]' >/dev/null
      echo 'dirty'
    else
      echo 'staged'
    end
  else
    echo 'clean'
  end
end

## Function to show current status
function show_git -d "Function to show git branch info"
  set -g _pad " "
  # Show git branch and status
  set -l git_branch (_git_branch_name)
  if test -n "$git_branch"
    switch (_git_status)
      case 'dirty'
        set color 'red'
      case 'staged'
        set color 'green'
      case 'clean'
        set color 'cyan'
      case 'unknown'
        set color 'white'
    end
    prompt_segment black $color " $git_branch "
  end

end

function fish_right_prompt
  set -g RETVAL $status
  show_status
  show_git
  prompt_segment normal normal ''
end
