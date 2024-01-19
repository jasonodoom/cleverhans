Vagrant.configure("2") do |config|
  # VM 1 Configuration
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "ubuntu/jammy64"
    
    # Network configuration for VM1
    vm1.vm.network "private_network", ip: "192.168.56.10"

    # Provision VM1 with intrusion tools
    vm1.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y nmap netcat
    SHELL
  end

  # VM 2 Configuration
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "ubuntu/jammy64"
    
    # Network configuration for VM2
    vm2.vm.network "private_network", ip: "192.168.57.10"

    vm2.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
    end

    # Provision VM2 with Nix, and Git for CleverHans
    vm2.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y curl git
      curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm

      # Setup environment for Nix
      echo '. $HOME/.nix-profile/etc/profile.d/nix.sh' >> $HOME/.bashrc

      # Clone and build CleverHans using Nix
      git clone https://github.com/jasonodoom/cleverhans
      cd cleverhans
      . $HOME/.nix-profile/etc/profile.d/nix.sh
      nix build .#cleverhans
    SHELL
  end
end