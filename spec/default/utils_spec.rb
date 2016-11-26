# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'kintone/cli'

describe Kintone_Cli::Utils do

  it "Tests for getting an environment" do
    envs = {
      'default' => {
        "user" => "default-user",
        "password" => "default-pass",
        "subdomain" => "default-subdomain"
      },
      'staging' => {
        "user" => "staging-user",
        "password" => "staging-pass",
        "subdomain" => "staging-subdomain"
      }
    }

    options = {
      "environment" => "staging"
    }

    result = Kintone_Cli::Utils::get_env( envs, options )
    expect( result ).to eq "user" => "staging-user",
        "password" => "staging-pass", "subdomain" => "staging-subdomain"
  end

  it "Tests for getting an environment with options (1)" do
    envs = {
      'default' => {
        "user" => "default-user",
        "password" => "default-pass",
        "subdomain" => "default-subdomain"
      },
      'staging' => {
        "user" => "staging-user",
        "password" => "staging-pass",
        "subdomain" => "staging-subdomain"
      }
    }

    options = {
      "environment" => "staging",
      "user" => "user",
      "password" => "pass",
      "subdomain" => "subdomain"
    }

    result = Kintone_Cli::Utils::get_env( envs, options )
    expect( result ).to eq "user" => "user",
        "password" => "pass", "subdomain" => "subdomain"
  end

  it "Tests for getting an environment with options (2)" do
    envs = {
      'default' => {
        "user" => "default-user",
        "password" => "default-pass",
        "subdomain" => "default-subdomain"
      },
      'staging' => {
        "user" => "staging-user",
        "password" => "staging-pass",
        "subdomain" => "staging-subdomain"
      }
    }

    options = {
      "environment" => "staging",
      "user" => "user"
    }

    result = Kintone_Cli::Utils::get_env( envs, options )
    expect( result['user'] ).to eq "user"
    expect( result['password'] ).to eq "staging-pass"
    expect( result['subdomain'] ).to eq "staging-subdomain"
  end

end
