# pipeline

ubuntu@ip-172-31-20-17:~$ git clone https://github.com/mohanwk123/pipeline.git
Cloning into 'pipeline'...
Username for 'https://github.com': mohanwk123
Password for 'https://mohanwk123@github.com': 
remote: Enumerating objects: 111, done.
remote: Counting objects: 100% (111/111), done.
remote: Compressing objects: 100% (50/50), done.
remote: Total 111 (delta 42), reused 87 (delta 23), pack-reused 0 (from 0)
Receiving objects: 100% (111/111), 11.84 KiB | 1.97 MiB/s, done.
Resolving deltas: 100% (42/42), done.
ubuntu@ip-172-31-20-17:~$ 
ubuntu@ip-172-31-20-17:~$ cd pipeline/
ubuntu@ip-172-31-20-17:~/pipeline$ git config credential.helper store
ubuntu@ip-172-31-20-17:~/pipeline$ git pull
Username for 'https://github.com': mohanwk123
Password for 'https://mohanwk123@github.com': 
Already up to date.
ubuntu@ip-172-31-20-17:~/pipeline$ git pull
Already up to date.


sudo apt update
sudo apt install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker $USER

