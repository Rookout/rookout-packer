shared_examples 'rookout::secure_ami' do

    describe 'SSH server configuration' do
        # Verify that the SSH server configuration file has been modified correctly
        describe file('/etc/ssh/sshd_config') do
          it { should exist }
          it { should be_file }
          it { should contain('PermitRootLogin without-password') }
        end
      
        # Verify that the SSH service has been reloaded successfully
        describe service('sshd') do
          it { should be_running }
        end
      end

    describe 'Root user configuration' do
    # Verify that the root user password has been locked
        describe user('root') do
            it { should exist }
            it { should have_login_shell('/sbin/nologin') }
        end
    
        # Verify that the root account has been disabled
        describe command('getent shadow root') do
            its(:stdout) { should match(/^root:!:.*$/) }
        end
    end

end