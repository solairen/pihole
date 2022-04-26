FROM moleszek/ansible:latest

RUN apt update && apt -y install wget git
RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
RUN chmod +x /usr/local/bin/oh-my-posh

RUN echo 'eval "$(oh-my-posh init bash --config /workspaces/pihole/.devcontainer/configuration/terminal.omp.json)"' >> ~/.bashrc
