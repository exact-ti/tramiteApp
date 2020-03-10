import 'dart:core';


class Usuario {
  
    String username;

    String password;

    bool estado;

	 String getUsername() {
		return this.username;
	}

	void setUsername(String username) {
		this.username = username;
	}

	 String getPassword() {
		return this.password;
	}

	void setPassword(String password) {
		this.password = password;
	}

	bool isEstado() {
		return this.estado;
	}

	void setEstado(bool estado) {
		this.estado = estado;
	}


    


}