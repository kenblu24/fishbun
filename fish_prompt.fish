# name: ocean
# A fish theme with ocean in mind.


## Set this options in your config.fish (if you want to)
# set -g theme_display_user yes
# set -g default_user default_username


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

function prompt_pwd --description 'short CWD for the prompt'
  set -l options h/help d/dir-length= D/full-length-dirs=
  argparse -n prompt_pwd $options -- $argv
  or return

  if set -q _flag_help
    __fish_print_help prompt_pwd
    return 0
  end

  set -q argv[1]
  or set argv $PWD

  set -ql _flag_d
  and set -l fish_prompt_pwd_dir_length $_flag_d

  set -q fish_prompt_pwd_dir_length
  or set -l fish_prompt_pwd_dir_length 1

  set -l fulldirs 0
  set -ql _flag_D
  and set -l fish_prompt_pwd_full_dirs $_flag_D

  set -q fish_prompt_pwd_full_dirs
  or set -l fish_prompt_pwd_full_dirs 1

  set -q fish_prompt_pwd_ellipsis
  or set -l fish_prompt_pwd_ellipsis "SMART"

  for path in $argv
    # Replace $HOME with "~"
    set -l realhome (string escape --style=regex -- ~)
    set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $path)

    if test "$fish_prompt_pwd_dir_length" -eq 0
      echo $tmp
    else
      # Shorten to at most $fish_prompt_pwd_dir_length characters per directory
      # with full-length-dirs components left at full length.
      set -l full
      if test $fish_prompt_pwd_full_dirs -gt 0
        # split into $tmp (stuff to be shortened) and $full (dir names that won't get changed)
        set -l all (string split -m (math $fish_prompt_pwd_full_dirs - 0) -r / $tmp)
        set tmp $all[1]
        set full $all[2..]
      else if test $fish_prompt_pwd_full_dirs -eq 0
        # 0 means not even the last component is kept
        string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*' '$1' $tmp
        continue
      end

      if set -q fish_prompt_pwd_ellipsis; and test -z "$fish_prompt_pwd_ellipsis"  # if empty string
        # shorten each path component in $tmp to $fish_prompt_pwd_dir_length
        string join / -- (string replace -ar -- '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' $tmp) $full
      else
        # replace ends of parts with ellipses (or custom character)
        set -g parts (string split / $tmp)
        if test "$fish_prompt_pwd_ellipsis" = "SMART"
          # let string shorten automatically choose ellipses
          for i in (seq (count $parts))
            set parts[$i] (string shorten -m $fish_prompt_pwd_dir_length $parts[$i])
          end
        else
          for i in (seq (count $parts))
            set parts[$i] (string shorten -m $fish_prompt_pwd_dir_length $parts[$i] -c $fish_prompt_pwd_ellipsis)
          end
        end
        string join / -- $parts $full
      end
    end
  end
end

## Function to show current status
# function show_status -d "Function to show the current status"
#   if [ $RETVAL -ne 0 ]
#     prompt_segment red white " ▲ "
#     set _pad ""
#     end
#   if [ -n "$SSH_CLIENT" ]
#       prompt_segment blue white " SSH: "
#       set _pad ""
#     end
# end

function show_virtualenv -d "Show active python virtual environments"
  if set -q fish_prompt_no_custom_virtualenv
    return
  end
  set -g VIRTUAL_ENV_DISABLE_PROMPT x
  if set -q VIRTUAL_ENV
    set -l venvname (basename "$VIRTUAL_ENV")
    prompt_segment normal brblack " $venvname"
  end
end

## Show user if not in default users
function show_user -d "Show user"
  if not contains $USER $default_user; or test -n "$SSH_CLIENT"
    set -l host (hostname -s)
    set -l who (whoami)
    prompt_segment normal brgreen " $who"

    # Skip @ bit if hostname == username
    if [ "$USER" != "$HOST" ]
      prompt_segment normal brgreen "@"
      prompt_segment normal brgreen "$host "
      set _pad ""
    end
  end
end

function _set_venv_project --on-variable VIRTUAL_ENV
  if set -q VIRTUAL_ENV
    if test -e $VIRTUAL_ENV/.project
      set -g VIRTUAL_ENV_PROJECT (cat $VIRTUAL_ENV/.project)
    end
  end
end

# Show directory
function show_pwd -d "Show the current directory"
  set -l pwd
  if [ (string match -r '^'"$VIRTUAL_ENV_PROJECT" $PWD) ]
    set pwd (string replace -r '^'"$VIRTUAL_ENV_PROJECT"'($|/)' '≫ $1' $PWD)
  else
    set pwd (prompt_pwd)
  end
  prompt_segment normal brblue "$_pad$pwd "
end

# Show prompt w/ privilege cue
function show_prompt -d "Shows prompt with cue for current priv"
  set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
    prompt_segment normal red " ! "
    set_color normal
    echo -n -s " "
  else
    prompt_segment normal white "❯ "
    end

  set_color normal
end

## SHOW PROMPT
function fish_prompt
  set -g RETVAL $status
  # Display custom prefix
  if functions -q fish_prompt_custom_prefix
    fish_prompt_custom_prefix
  end
  show_virtualenv
  show_user
  show_pwd
  show_prompt
  set -g RETVAL 0
end
