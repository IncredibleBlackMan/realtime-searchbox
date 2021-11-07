require 'rails_helper'

RSpec.describe SearchAnalytic, type: :model do
  describe 'create search analytic' do
    context 'when successful' do
      let(:user) { create(:user)}
      let(:analytics_params) { attributes_for(:search_analytic) }

      it 'creates search analytic' do
        expect do
          user.search_analytics.create!(analytics_params)
        end.to change(SearchAnalytic, :count).by 1
      end
    end
  end
end
