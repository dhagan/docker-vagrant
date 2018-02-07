# -*- mode: ruby -*-

# vi: set ft=ruby :

vagrant_arg = ARGV[0]
if vagrant_arg == 'up'
  print "Collecting credentials to pull source from bitbucket\n"
  print "Please enter bitbucket username: "
  STDOUT.flush
  username = STDIN.gets.chomp
  # 8m is the control code to hide characters
  print "Please enter bitbucket password: \e[0;8m"
  STDOUT.flush
  password = STDIN.gets.chomp
  # 0m is the control code to reset formatting attributes
  puts "\e[0m"
  STDOUT.flush
end

# required_plugins = %w( vagrant-hostmanager vagrant-triggers vagrant-vbguest )
# plugin_installed = false
# required_plugins.each do |plugin|
#   unless Vagrant.has_plugin?(plugin)
#     system "vagrant plugin install #{plugin}"
#     plugin_installed = true
#   end
# end
 
# plugin_installed = true

# # If new plugins installed, restart Vagrant process
# if plugin_installed === true
#   exec "vagrant #{ARGV.join' '}"
# end
#:forwards => {80 => 1090, 8080 => 5080, 8081 => 5081, 4444 => 4444, 4201 => 4201, 4873 => 4873, 8090 => 5090 },

boxes = [
  {   :name => :dockerenv,
      :group => "dockerenv",
      :boxipaddress => "192.168.100.10",
      :mem => "2048",
      :sshcommands => [
        'if [ ! -f "/home/vagrant/.ssh/id_rsa" ]; then ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa; fi',
        'if [ -f "/home/vagrant/.ssh/id_rsa.pub" ]; then cp /home/vagrant/.ssh/id_rsa.pub /vagrant/dockerenv.pub; fi',
        'cat /vagrant/ssh_config >> /home/vagrant/.ssh/config',
        'chown -R vagrant:vagrant /home/vagrant/.ssh/',
      ],
      :commands => [
        'sudo yum -y clean all',
        'sudo yum makecache fast',
        'sudo yum -y update yum-utils',
        'sudo yum -y install git epel-release',
        'sudo yum install -y nodejs java-1.8.0-openjdk fontconfig freetype freetype-devel fontconfig-devel libstdc++ bzip2',
        'sudo yum install -y yum-utils device-mapper-persistent-data lvm2',
        'sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo',
        'sudo yum-config-manager --enable docker-ce-edge',
        'sudo yum install -y docker-ce',
        'sudo usermod -aG docker vagrant',
        'sudo setsebool -P samba_enable_home_dirs 1',
        'sudo sysctl -w net.ipv4.ip_forward=1',
        'sudo yum install samba -y',
        'sudo systemctl enable smb nmb docker',
        'sudo systemctl start smb nmb docker',
        'sudo sed -i.original "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config',
        'sudo systemctl restart sshd',
        'sudo cp -R /vagrant/docker /home/vagrant/docker',
        'sudo chmod +x /home/vagrant/docker/prepare.sh',
        'sudo cp /vagrant/setup_passwords.sh /home/vagrant/setup_passwords.sh',
        'sudo chmod +x /home/vagrant/setup_passwords.sh',
        'sudo cp /vagrant/enable_routing.sh /usr/local/bin/enable_routing.sh',
        'sudo chmod +x /usr/local/bin/enable_routing.sh',
        'sudo cp /vagrant/enable_routing.service /etc/systemd/system/enable_routing.service',
        'sudo systemctl daemon-reload',
        'sudo systemctl enable enable_routing',
        'sudo systemctl start enable_routing',
        'sudo cp /vagrant/docker-compose /usr/local/bin/docker-compose',
        'sudo chmod +x /usr/local/bin/docker-compose',
        'sudo chown -R vagrant:vagrant /home/vagrant',
        # 'docker pull nginx', # these are all optional; they're merely preloading
        # 'docker pull tomcat',
        # 'docker pull centos:7',
        # 'docker pull node:8.9-alpine'
      ]
  }
]

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.hostmanager.enabled = true
  config.vm.box = "centos/7"
  config.vm.box_version = "1801.02"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  boxes.each do |opts|
    config.vm.define opts[:name] do |box|
      # Box basics
      box.vm.hostname = "%s" % [ opts[:name].to_s ]
      box.vm.network :private_network, ip: opts[:boxipaddress]

      unless opts[:gui].nil?
        box.vm.provider "virtualbox" do |v|
          v.gui = [ opts[:gui] ]
        end
        if opts[:gui]
          box.vm.provision :shell, :inline => $getDesktop
        end
      end

      # # VirtualBox port forwarding
      # unless opts[:forwards].nil?
      #   box.vm.provision "shell", :inline => "echo perform port forwards"
      #   opts[:forwards].each do |guest_port,host_port|
      #     box.vm.network :forwarded_port, guest: guest_port, host: host_port
      #   end if opts[:forwards]
      # end

      # VirtualBox set virtual memory
      unless opts[:gram].nil?
        box.vm.provision "shell", :inline => "echo modifying virtual memory"
        box.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--vram", "128"]
        end
      end

      # VirtualBox set memory
      unless opts[:mem].nil?
        box.vm.provision "shell", :inline => "echo modifying memory"
        box.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        end
      end

      # # VirtualBox Synced folders
      # unless opts[:synced_folders].nil?
      #   box.vm.provision "shell", :inline => "echo preparing synced folders"
      #   opts[:synced_folders].each do |hash|
      #     hash.each do |folder1, folder2|
      #       box.vm.provision "shell", :inline => "echo prepare to sync folder #{folder1} -- #{folder2}"
      #       if File.directory?(File.expand_path(folder1))
      #           box.vm.provision "shell", :inline => "echo sync #{folder1}"
      #           box.vm.synced_folder "#{folder1}", "#{folder2}"
      #       end
      #     end
      #   end
      # end
      #
      # Due to network manager bug (https://github.com/mitchellh/vagrant/issues/8096), always restart the network interface when bringing up the VM
      #
      box.vm.provision :shell, :inline => "sudo service network restart", :run => 'always'
      #
      # Run specified sshcommands
      unless opts[:sshcommands].nil?
        box.vm.provision "shell", :inline => "echo Run specified sshcommands"
        opts[:sshcommands].each do |sshcommand|
          box.vm.provision :shell, :inline => sshcommand
        end
      end

      # Run commands specific to box
      unless opts[:commands].nil?
        opts[:commands].each do |command|
          box.vm.provision "shell", :inline => "echo running command: #{command}"
          box.vm.provision :shell, :inline => command
        end
      end

      box.vm.provision "shell", :inline => "echo prepare docker workspace"
      box.trigger.after :up, :stdout => true, :stderr => true do
        password_cmd = "sudo ./setup_passwords.sh vagrant #{password}"
        prepare_cmd = "./prepare.sh #{username} #{password}"
        run "vagrant ssh dockerenv -c \"cd ~; #{password_cmd} && cd ~/docker && #{prepare_cmd}\""
      end
    end
  end
end

