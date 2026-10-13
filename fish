function ussh --description 'Usuń hosta z known_hosts'
    set -l host
    if test (count $argv) -gt 0
        set host $argv[1]
    else
        set -l cmd (history search --prefix 'ssh ' --max 1)
        if test -z "$cmd"
            echo "Brak polecenia ssh w historii"
            return 1
        end
        set -l args (string split -n ' ' -- (string replace -r '^ssh\s+' '' -- $cmd))
        set -l cfg (ssh -G $args 2>/dev/null)
        set host (string match -r '^hostname (.+)' -- $cfg)[2]
        set -l port (string match -r '^port (.+)' -- $cfg)[2]
        if test -n "$port"; and test "$port" != 22
            set host "[$host]:$port"
        end
    end
    echo "Usuwam: $host"
    ssh-keygen -f ~/.ssh/known_hosts -R $host
end