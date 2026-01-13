function logout
    echo "Logging out $USER..."
    loginctl kill-user $USER
end

