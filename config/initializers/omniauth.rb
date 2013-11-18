Rails.application.config.middleware.use OmniAuth::Builder do


  provider :google_oauth2, 
    '130227135581-694ki4va446epae6tcf3clgi08itq0mm.apps.googleusercontent.com', 
    '3tkE-uSq51owFT6yrEXmhP_I',
    {
      :scope => "userinfo.email"
    }  
end