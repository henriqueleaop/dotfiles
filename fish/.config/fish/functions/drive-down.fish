function drive-down -d "Desmonta o Google Drive"
    fusermount3 -u ~/Drive
    echo "Google Drive desmontado"
end
