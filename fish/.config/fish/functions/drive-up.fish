function drive-up -d "Monta o Google Drive"
	rclone mount gdrive: ~/Drive --vfs-cache-mode writes --daemon
	echo "Google Drive montado em ~/Drive"
end
