!/bin/bash

# will ask $1 question and ensure output is y or n
function y_or_n () {

  read -e -t 300 -i "y" -p "$1: [Y/n]: " choice

  if [ "$choice" == 'y' ] || [ "$choice" == 'n' ]; then
    echo $choice;
  elif [ "$choice" == '' ]; then
    echo 'y';
  else
    y_or_n "$1"
  fi
}

function base_os () {
  echo "OK, booting into base OS instead.";
  sleep 3;
  exit 0;
}

function main_os () {

  echo "OK, booting into main OS. This session will terminate now."
  sleep 3

  mount /dev/nvme0n1p1 /mnt/nvme
  kexec -l /mnt/nvme/vmlinuz --append="rootwait root=/dev/nvme0n1p1" --initrd=/mnt/nvme/initrd.img
  sync
  #umount -a # this will fail, also unmounting is done by kexec anyway
  kexec -e
  exit 0;
}

selected=$(y_or_n 'Shall we kexec into MAIN OS?')

if [ "$selected" = "y" ]; then
  main_os
else
  base_os
fi