package net.kadirderer.btc.security;

import net.kadirderer.btc.service.BtcAuthenticationService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

@Component
public class BtcAuthenticationProvider extends DaoAuthenticationProvider {
	
	@Autowired
	private BtcAuthenticationService authService;
	
	@Override
	public Authentication authenticate(Authentication arg0)
			throws AuthenticationException {
		
		Authentication auth = super.authenticate(arg0);
		authService.updateLastLoginTime(auth.getName());
		
		return auth;
	}
	
	@Override
	@Qualifier("userDetailsService")
	@Autowired
	public void setUserDetailsService(UserDetailsService userDetailsService) {
		super.setUserDetailsService(userDetailsService);
	}
	
}
