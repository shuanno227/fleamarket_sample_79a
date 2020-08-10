# require 'rails_helper'
#
# describe CreditCardsController do
#   describe 'POST #create' do
#
#     before do
#       payjp_customer = double('Payjp::Customer')
#       payjp_list     = double('Payjp::ListObject')
#       payjp_card     = double('Payjp::Card')
#       allow(Payjp::Customer).to receive(:create).and_return(payjp_customer)
#       allow(payjp_customer).to receive(:cards).and_return(payjp_list)
#       allow(payjp_list).to receive(:create).and_return(payjp_card)
#       allow(payjp_customer).to receive(:id).and_return('cus_xxxxxxxxxxxxx')
#     end
#
#     it '@cardが定義されていること' do
#       post :create, params: { token: 'tok_xxxxxxxx' }
#       credit = create(:credit, user_id: user.id, customer_id: 'cus_xxxxxxxxxxxxx')
#       expect(assigns(:credit).customer_id).to eq(credit.customer_id)
#     end
#
#   end
# end
