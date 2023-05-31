require 'spec_helper'
require 'shared/rookout/base'

describe 'OnPrem Components Tests' do
    include_examples 'rookout::base'
end

describe 'Secure AMI Tests ' do
    include_examples 'rookout::secure_ami'
end