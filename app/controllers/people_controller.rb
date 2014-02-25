class PeopleController < ApplicationController

  def create
    @person = Person.new

    if @person.save
      redirect_to :back, notice: 'Person was successfully created.'
    else
      render action: 'new'
    end
  end
end

#what exactly do i create??
