# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Profiles::TwoFactorAuthsController do
  before do
    # `user` should be defined within the action-specific describe blocks
    sign_in(user)

    allow(subject).to receive(:current_user).and_return(user)
  end

  shared_examples 'user must first verify their primary email address' do
    before do
      allow(user).to receive(:primary_email_verified?).and_return(false)
    end

    it 'redirects to profile_emails_path' do
      go

      expect(response).to redirect_to(profile_emails_path)
    end

    it 'displays a notice' do
      go

      expect(flash[:notice])
        .to eq _('You need to verify your primary email first before enabling Two-Factor Authentication.')
    end

    it 'does not redirect when the `ensure_verified_primary_email_for_2fa` feature flag is disabled' do
      stub_feature_flags(ensure_verified_primary_email_for_2fa: false)

      expect(response).not_to redirect_to(profile_emails_path)
    end
  end

  describe 'GET show' do
    let_it_be_with_reload(:user) { create(:user) }

    it 'generates otp_secret for user' do
      expect(User).to receive(:generate_otp_secret).with(32).and_call_original.once

      get :show
    end

    it 'assigns qr_code' do
      code = double('qr code')
      expect(subject).to receive(:build_qr_code).and_return(code)

      get :show
      expect(assigns[:qr_code]).to eq code
    end

    it 'generates a unique otp_secret every time the page is loaded' do
      expect(User).to receive(:generate_otp_secret).with(32).and_call_original.twice

      2.times do
        get :show
      end
    end

    it_behaves_like 'user must first verify their primary email address' do
      let(:go) { get :show }
    end
  end

  describe 'POST create' do
    let_it_be_with_reload(:user) { create(:user) }

    let(:pin) { 'pin-code' }

    def go
      post :create, params: { pin_code: pin }
    end

    context 'with valid pin' do
      before do
        expect(user).to receive(:validate_and_consume_otp!).with(pin).and_return(true)
      end

      it 'enables 2fa for the user' do
        go

        user.reload
        expect(user).to be_two_factor_enabled
      end

      it 'presents plaintext codes for the user to save' do
        expect(user).to receive(:generate_otp_backup_codes!).and_return(%w(a b c))

        go

        expect(assigns[:codes]).to match_array %w(a b c)
      end

      it 'calls to delete other sessions' do
        expect(ActiveSession).to receive(:destroy_all_but_current)

        go
      end

      it 'dismisses the `TWO_FACTOR_AUTH_RECOVERY_SETTINGS_CHECK` callout' do
        expect(controller.helpers).to receive(:dismiss_two_factor_auth_recovery_settings_check)

        go
      end

      it 'renders create' do
        go
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid pin' do
      before do
        expect(user).to receive(:validate_and_consume_otp!).with(pin).and_return(false)
      end

      it 'assigns error' do
        go
        expect(assigns[:error]).to eq _('Invalid pin code')
      end

      it 'assigns qr_code' do
        code = double('qr code')
        expect(subject).to receive(:build_qr_code).and_return(code)

        go
        expect(assigns[:qr_code]).to eq code
      end

      it 'renders show' do
        go
        expect(response).to render_template(:show)
      end
    end

    it_behaves_like 'user must first verify their primary email address'
  end

  describe 'POST codes' do
    let_it_be_with_reload(:user) { create(:user, :two_factor) }

    it 'presents plaintext codes for the user to save' do
      expect(user).to receive(:generate_otp_backup_codes!).and_return(%w(a b c))

      post :codes
      expect(assigns[:codes]).to match_array %w(a b c)
    end

    it 'persists the generated codes' do
      post :codes

      user.reload
      expect(user.otp_backup_codes).not_to be_empty
    end

    it 'dismisses the `TWO_FACTOR_AUTH_RECOVERY_SETTINGS_CHECK` callout' do
      expect(controller.helpers).to receive(:dismiss_two_factor_auth_recovery_settings_check)

      post :codes
    end
  end

  describe 'DELETE destroy' do
    subject { delete :destroy }

    context 'for a user that has 2FA enabled' do
      let_it_be_with_reload(:user) { create(:user, :two_factor) }

      it 'disables two factor' do
        subject

        expect(user.reload.two_factor_enabled?).to eq(false)
      end

      it 'redirects to profile_account_path' do
        subject

        expect(response).to redirect_to(profile_account_path)
      end

      it 'displays a notice on success' do
        subject

        expect(flash[:notice])
          .to eq _('Two-factor authentication has been disabled successfully!')
      end
    end

    context 'for a user that does not have 2FA enabled' do
      let_it_be_with_reload(:user) { create(:user) }

      it 'redirects to profile_account_path' do
        subject

        expect(response).to redirect_to(profile_account_path)
      end

      it 'displays an alert on failure' do
        subject

        expect(flash[:alert])
          .to eq _('Two-factor authentication is not enabled for this user')
      end
    end
  end
end
