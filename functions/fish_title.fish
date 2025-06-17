set dist_name (lsb_release -i | awk '{print $NF}')

function fish_ellipsis
  echo (string shorten -m 3 '    ' | string trim)
end

function fish_unicode_check
  if test (string length (fish_ellipsis)) -eq 1
    return 0
  else
    return 1
  end
end


function title_pwd --description 'shorter CWD for the title'
  set -l options h/help d/dir-length= D/full-length-dirs=
  argparse -n title_pwd $options -- $argv
  or return

  if set -q _flag_help
    __fish_print_help title_pwd
    return 0
  end

  set -q argv[1]
  or set argv $PWD

  set -ql _flag_d
  and set -l fish_title_pwd_dir_length $_flag_d

  set -q fish_title_pwd_dir_length
  or set -l fish_title_pwd_dir_length 1

  set -l fulldirs 0
  set -ql _flag_D
  and set -l fish_title_pwd_full_dirs $_flag_D

  set -q fish_title_pwd_full_dirs
  or set -l fish_title_pwd_full_dirs 1

  for path in $argv
    # Replace $HOME with "~"
    set -l realhome (string escape --style=regex -- ~)
    set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $path)

    if test "$fish_title_pwd_dir_length" -eq 0
      echo $tmp
    else
      # Shorten to at most $fish_title_pwd_dir_length characters per directory
      # with full-length-dirs components left at full length.
      set -l full
      if test $fish_title_pwd_full_dirs -gt 0
        set -l all (string split -m (math $fish_title_pwd_full_dirs) -r / $tmp)
        set tmp $all[1]
        set full $all[2..]
      # else if test $fish_title_pwd_dirs -eq 0
      #   # 0 means not even the last component is kept
        # set tmp (string replace -r '(~?/?)(\.?[^/]{'"$fish_title_pwd_dir_length"'})[^/]*' (fish_ellipsis)'$2' $tmp)
        set tmp (string replace -r '^(~?)(.*)' '$2' $tmp)
        if test -n "$tmp"
          string join / -- (fish_ellipsis) $full
        else
          echo $full
        end
      #   continue
      end
    end
  end
end


function title_reverse_parts
  for i in (seq (count $argv) -1 1)
    echo $argv[$i]
  end
end


function title_rev_pwd --description 'reversed CWD for the title'
  set -l options h/help d/dir-length= D/full-length-dirs=
  argparse -n title_pwd $options -- $argv
  or return

  if set -q _flag_help
    __fish_print_help title_pwd
    return 0
  end

  set -q argv[1]
  or set argv $PWD

  if set -q fish_title_pwd_rev_sep
  else if fish_unicode_check
    set -g fish_title_pwd_rev_sep ‹
  else
    set -g fish_title_pwd_rev_sep \<
  end

  if set -q fish_title_pwd_home
  else if fish_unicode_check
    set -g fish_title_pwd_home \U1F3E0
  else
    set -g fish_title_pwd_home '~'
  end

  for path in $argv
    # Replace $HOME with "~"
    set -l realhome (string escape --style=regex -- ~)
    set -l tmp (string replace -r '^'"$realhome"'($|/)' $fish_title_pwd_home'$1' $path)

    set -l all (string split -r / $tmp)

    string join $fish_title_pwd_rev_sep (title_reverse_parts $all)

  end
end


function fish_title
  # echo $dist_name' '
  echo (status current-command)' '
  echo (title_rev_pwd)' '
end
