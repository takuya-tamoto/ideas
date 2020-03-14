class ContactsController < ApplicationController
  
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact).deliver
      flash[:success] = 'お問合せを受付けました'
      redirect_to root_url
    else
       flash.now[:danger] = 'お問合せに失敗しました。'
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :message)
  end
end