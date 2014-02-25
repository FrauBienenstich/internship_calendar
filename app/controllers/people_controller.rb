class PeopleController < ApplicationController

  def create
    @people = People.new(slot_params)

    if @people.save
      redirect_to @people, notice: 'Person was successfully created.'
    else
      render action: 'new'
    end
  end
end

#what exactly do i create??
