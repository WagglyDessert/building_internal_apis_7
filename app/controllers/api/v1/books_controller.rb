class Api::V1::BooksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def index
    render json: BookSerializer.new(Book.all)
  end

  def show
    # begin
      render json: BookSerializer.new(Book.find(params[:id]))
    # rescue ActiveRecord::RecordNotFound => exception
    #   render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    #   .serialize_json, status: :not_found
    # end
  end

  def create
    new_book = Book.create(book_params)
    render json: BookSerializer.new(new_book)
  end

  def update
    book = Book.find(params[:id])
    book.update(book_params)
    render json: BookSerializer.new(book)
  end
  
  def destroy
    book = Book.find(params[:id])
    book.destroy
    render json: BookSerializer.new(book)
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :summary, :genre, :number_sold)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end