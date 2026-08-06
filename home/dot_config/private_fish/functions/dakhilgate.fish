function dakhilgate
    if not tmux has-session -t dakhilgate 2>/dev/null
        tmux start-server 2>/dev/null
        for i in (seq 1 20)
            tmux has-session -t dakhilgate 2>/dev/null; and break
            sleep 0.5
        end
    end
    tmux new-session -A -s dakhilgate
end
