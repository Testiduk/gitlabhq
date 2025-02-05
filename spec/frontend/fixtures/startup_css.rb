# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Startup CSS fixtures', type: :controller do
  include JavaScriptFixturesHelpers

  let(:use_full_html) { true }

  render_views

  before(:all) do
    clean_frontend_fixtures('startup_css/')
  end

  shared_examples 'startup css project fixtures' do |type|
    let(:user) { create(:user, :admin) }
    let(:project) { create(:project, :public, :repository, description: 'Code and stuff', creator: user) }

    before do
      sign_in(user)
    end

    it "startup_css/project-#{type}.html" do
      get :show, params: {
        namespace_id: project.namespace.to_param,
        id: project
      }

      expect(response).to be_successful
    end

    it "startup_css/project-#{type}-signed-out.html" do
      sign_out(user)

      get :show, params: {
        namespace_id: project.namespace.to_param,
        id: project
      }

      expect(response).to be_successful
    end

    # This Feature Flag is off by default
    # This ensures that the correct css is generated
    # When the feature flag is off, the general startup will capture it
    # This will be removed as part of https://gitlab.com/gitlab-org/gitlab/-/issues/339348
    it "startup_css/project-#{type}-search-ff-on.html" do
      stub_feature_flags(new_header_search: true)

      get :show, params: {
        namespace_id: project.namespace.to_param,
        id: project
      }

      expect(response).to be_successful
    end
  end

  describe ProjectsController, '(Startup CSS fixtures)', type: :controller do
    it_behaves_like 'startup css project fixtures', 'general'
  end

  describe ProjectsController, '(Startup CSS fixtures)', type: :controller do
    before do
      user.update!(theme_id: 11)
    end

    it_behaves_like 'startup css project fixtures', 'dark'
  end

  describe RegistrationsController, '(Startup CSS fixtures)', type: :controller do
    it 'startup_css/sign-in.html' do
      get :new

      expect(response).to be_successful
    end
  end
end
