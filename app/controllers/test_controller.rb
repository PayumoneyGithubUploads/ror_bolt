
# Configurable parameters... change below as per your subscription to PayU
	
	$returnUrl 	= 'http://localhost:3000/test/callback' # change is as required by your app
 	
 # end of configurable parameters


class TestController < ApplicationController
	skip_before_filter :authenticate

	def index
 		
  		
  	end
  
  	def calchash
  		data = 	params[:key] + "|" + params[:txnid] + "|" + params[:amount] +"|" + params[:pinfo] + "|" + params[:fname] + "|" + params[:email] + "|||||" + params[:udf5] + "||||||" + params[:salt]
  		hash=Digest::SHA512.hexdigest(data)
		
  		respond_to do |format|
      		format.json { render :json => {:success => hash} }
    	end
  	end
  
  	def callback 	# to be called by PayU to post response
  		@key = params[:key]
  		@salt = params[:salt]
  		@txnid = params[:txnid]
  		@amount = params[:amount]
  		@pinfo = params[:productinfo]
  		@fname = params[:firstname]
  		@email = params[:email]
  		@udf5 = params[:udf5]
  		@mihpayid = params[:mihpayid]
  		@status = params[:status]
  		@hash = params[:hash]
  		
  		# Verify response hash
		data = "|||||" + @udf5 + "|||||" + @email + "|" + @fname + "|" + @pinfo + "|" + @amount + "|" + @txnid + "|" + @key 
		
		@CalcHash 	= Digest::SHA512.hexdigest(@salt + "|" + @status + "|" + data)
	
		@msg = "Payment failed for Hasn not verified..."

		if @status === "success"  && @hash === @CalcHash
			@msg = "Transaction Successful and Hash Verified..."
		end
 	end 
 	#end of response
  
end

