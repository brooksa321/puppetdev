require 'spec_helper'

describe 'freetds', :type => :class do   
  describe 'when odbc is managed' do
    let(:params) { {
      :manage_unixodbc => true
    } }
      
    it { should contain_package('unixodbc') }
    it { should contain_package('unixodbc-dev') }
  end

  describe 'when odbc is not managed' do
    let(:params) { {
      :manage_unixodbc => false
    } }
      
    it { should_not contain_package('unixodbc') }
    it { should_not contain_package('unixodbc-dev') }
  end

  describe 'when freetds version is specified' do
    let(:params) { {
      :freetds_version => '2'
    } }
    
    it { should contain_package('freetds-dev').with_ensure('2') }
    it { should contain_package('freetds-bin').with_ensure('2') }
    it { should contain_package('tdsodbc').with_ensure('2') }
  end

  describe 'when applied should manage /etc/odbcinst.ini' do
    it { should contain_ini_setting('FreeTDS Description').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Description',
      :value   => 'FreeTDS Driver'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Driver').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Driver',
      :value   => '/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so'
    ).with_ensure('present')}

    it { should contain_ini_setting('FreeTDS Setup').with(
      :path    => '/etc/odbcinst.ini',
      :section => 'FreeTDS',
      :setting => 'Setup',
      :value   => '/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so'
    ).with_ensure('present')}
  end

  describe 'when applied should manage the global port' do
    let(:params) { {
      :global_port => '1337'
    } }

    it { should contain_ini_setting('FreeTDS Global Port').with(
      :path    => '/etc/freetds/freetds.conf',
      :section => 'global',
      :setting => 'port',
      :value   => '1337'
     ).with_ensure('present')}
  end

  describe 'when applied should mange the global tds version' do
    let(:params) { {
      :global_tds_version => '18'
    } }    
   
    it { should contain_ini_setting('FreeTDS Global tds version').with(
      :path    => '/etc/freetds/freetds.conf',
      :section => 'global',
      :setting => 'tds version',
      :value   => '18'
    ).with_ensure('present')}
  end

  describe 'the freetds conf should be managed before freetds is install' do
    it { should contain_ini_setting('FreeTDS Global tds version')
                .that_comes_before('Package[freetds-bin]')}
    it { should contain_ini_setting('FreeTDS Global Port')
                .that_comes_before('Package[freetds-bin]')}
  end
end
