# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DependencyProxy::ImageTtlGroupPolicy, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:group) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:group) }

    describe '#enabled' do
      it { is_expected.to allow_value(true).for(:enabled) }
      it { is_expected.to allow_value(false).for(:enabled) }
      it { is_expected.not_to allow_value(nil).for(:enabled) }
    end

    describe '#ttl' do
      it { is_expected.to validate_numericality_of(:ttl).allow_nil.is_greater_than(0) }
    end
  end
end
