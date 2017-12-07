class DojosController < ApplicationController
    def index
        @dojos = Dojo.all
    end

    def new
    end

    def check_errors(errors, destination)
        errors.each do |error|
            flash[:branch] = error if error[0..5] == 'Branch'
            flash[:street] = error if error[0..5] == 'Street'
            flash[:city] = error if error[0..3] == 'City'
            flash[:state] = error if error[0..4] == 'State'
        end
        return redirect_to "/dojos/#{destination}"
    end

    def find(id_num)
        search = Dojo.where(id: id_num)
        @dojo = search[0] if search.length > 0
        if search.length < 1
            flash[:error] = "Could not find Dojo with id #{id_num}"
            return redirect_to '/dojos'
        end
        return @dojo
    end

    def create
        errors = Dojo.create(dojo_params).errors.full_messages
        return check_errors(errors, 'new') if errors.length > 0
        return redirect_to '/dojos'
    end

    def show
        @dojo = find(params[:id])
        return render 'dojo'
    end

    def edit
        @dojo = find(params[:id])
        return render 'edit'
    end

    def update
        @dojo = find(params[:id])
        worked = @dojo.update(dojo_params)
        return check_errors(@dojo.errors.full_messages, "#{params[:id]}/edit") unless worked
        return redirect_to "/dojos/#{params[:id]}"
    end

    def destroy
        @dojo = find(params[:id])
        @dojo.destroy
        return redirect_to '/dojos'
    end

    private
    def dojo_params
        params.require(:dojo).permit(:branch, :street, :city, :state)
    end
end
