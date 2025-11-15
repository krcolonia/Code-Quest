extends Node

# ? this project originally used firebase as it's backend, but due to google being increasingly annoying by the minute,
# ? i've decided to completely rewrite the backend using supabase. we used to have a good thing google, why ruin it??? -krColonia

func register(email:String, password:String) -> void:
    Supabase.auth.sign_up(email, password)