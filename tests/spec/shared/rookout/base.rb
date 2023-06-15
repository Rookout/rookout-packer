shared_examples 'rookout::base' do

    describe service('docker') do
        it { should be_enabled }
        it { should be_running }
    end

    describe service('rookout-controller') do
        it { should be_enabled }
        it { should be_running }
    end


    max_retries = 3
    retry_count = 0
    expected_status = "healthy"

    loop do
        cmd_output = command("docker inspect --format='{{json .State.Health.Status}}' rookout-controller | tr -d '\"'").stdout.chomp
        if cmd_output == expected_status
            break  # Success, exit the loop
        else
            retry_count += 1
            if retry_count > max_retries
                # Max retries exceeded, fail the test
                fail "Max retries exceeded. Expected status: #{expected_status}, Actual status: #{cmd_output}"
            end
            sleep 15  # Wait for a few seconds before retrying
        end
    end

    # Assert the expected status
    describe command("docker inspect --format='{{json .State.Health.Status}}' rookout-controller | tr -d '\"'") do
        its(:stdout) { should eq "healthy\n"  }
    end


    describe service('rookout-data-on-prem') do
        it { should be_enabled }
        it { should be_running }
    end

    retry_count = 0
    
    loop do
        cmd_output = command("docker inspect --format='{{json .State.Health.Status}}' rookout-data-onprem| tr -d '\"'").stdout.chomp
        if cmd_output == expected_status
            break  # Success, exit the loop
        else
            retry_count += 1
            if retry_count > max_retries
                # Max retries exceeded, fail the test
                fail "Max retries exceeded. Expected status: #{expected_status}, Actual status: #{cmd_output}"
            end
            sleep 15  # Wait for a few seconds before retrying
        end
    end

    # Assert the expected status
    describe command("docker inspect --format='{{json .State.Health.Status}}' rookout-data-onprem | tr -d '\"'") do
        its(:stdout) { should eq "healthy\n" }
    end

    describe command("curl -s -o /dev/null -w '%{response_code}' localhost:7488") do
        its(:stdout) { should eq '200' }
    end

    describe command("curl -s -o /dev/null -w '%{response_code}' localhost:8080") do
        its(:stdout) { should eq '200' }
    end


end