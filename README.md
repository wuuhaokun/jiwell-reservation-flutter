# jiwell_reservation

https://www.linkedin.com/in/chaokun-wu-4742b7202/
https://www.cakeresume.com/onboarding/import_linkedin

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

//https://blog.csdn.net/oZhuiMeng123/article/details/104619426


Google play 上架教學
https://owl.cmoney.com.tw/Owl/tutorial/list.do?id=1ab170b0f9c511e8be97000c29e493f4

Flutter打包apk
https://www.jianshu.com/p/fabcfd621e01
https://blog.csdn.net/joye123/article/details/94588949

Android bug
Flutter 添加新插件后报The number of method references in a .dex file cannot exceed 64K
dex file cannot exceed 64K
https://juejin.im/post/6844904048034856967
https://shioulo.eu5.org/node/750

application ID:com.jiwell.reservation

遇到的問題。build成APK網路無法連線 參考如下 （debug模式預設可以連網，發布模式則要手動）
https://stackoverflow.com/questions/54955789/flutter-image-network-not-working-on-release-apk

在 Android 9.0 以上，HTTP 連線出現 net::ERR_CLEARTEXT_NOT_PERMITTED 錯誤？
https://ephrain.net/cordova-在-android-9-0-以上，http-連線出現-neterr_cleartext_not_permitted-錯誤？

訂餐系統參考
http://www.admin.ltu.edu.tw:8000/Public/Upload/files/資管系/102學年度四技畢業專題/10205.pdf

Flutter
1.https://ithelp.ithome.com.tw/articles/10215158
2.https://ithelp.ithome.com.tw/users/20120028/ironman/2263 
3.https://ithelp.ithome.com.tw/users/20103043/ironman/2186

影
https://www.youtube.com/playlist?list=PLt85kdOx9ozWwcy6FVOquYNMah12FTWbP



相关方法说明：

generateToken(UserDetails userDetails) :用于根据登录用户信息生成token
getUserNameFromToken(String token)：从token中获取登录用户的信息
validateToken(String token, UserDetails userDetails)：判断token是否还有效
package com.macro.mall.tiny.common.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JwtToken生成的工具类
 * Created by macro on 2018/4/26.
 */
@Component
public class JwtTokenUtil {
    private static final Logger LOGGER = LoggerFactory.getLogger(JwtTokenUtil.class);
    private static final String CLAIM_KEY_USERNAME = "sub";
    private static final String CLAIM_KEY_CREATED = "created";
    @Value("${jwt.secret}")
    private String secret;
    @Value("${jwt.expiration}")
    private Long expiration;

    /**
     * 根据负责生成JWT的token
     */
    private String generateToken(Map<String, Object> claims) {
        return Jwts.builder()
                .setClaims(claims)
                .setExpiration(generateExpirationDate())
                .signWith(SignatureAlgorithm.HS512, secret)
                .compact();
    }

    /**
     * 从token中获取JWT中的负载
     */
    private Claims getClaimsFromToken(String token) {
        Claims claims = null;
        try {
            claims = Jwts.parser()
                    .setSigningKey(secret)
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            LOGGER.info("JWT格式验证失败:{}",token);
        }
        return claims;
    }

    /**
     * 生成token的过期时间
     */
    private Date generateExpirationDate() {
        return new Date(System.currentTimeMillis() + expiration * 1000);
    }

    /**
     * 从token中获取登录用户名
     */
    public String getUserNameFromToken(String token) {
        String username;
        try {
            Claims claims = getClaimsFromToken(token);
            username =  claims.getSubject();
        } catch (Exception e) {
            username = null;
        }
        return username;
    }

    /**
     * 验证token是否还有效
     *
     * @param token       客户端传入的token
     * @param userDetails 从数据库中查询出来的用户信息
     */
    public boolean validateToken(String token, UserDetails userDetails) {
        String username = getUserNameFromToken(token);
        return username.equals(userDetails.getUsername()) && !isTokenExpired(token);
    }

    /**
     * 判断token是否已经失效
     */
    private boolean isTokenExpired(String token) {
        Date expiredDate = getExpiredDateFromToken(token);
        return expiredDate.before(new Date());
    }

    /**
     * 从token中获取过期时间
     */
    private Date getExpiredDateFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims.getExpiration();
    }

    /**
     * 根据用户信息生成token
     */
    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put(CLAIM_KEY_USERNAME, userDetails.getUsername());
        claims.put(CLAIM_KEY_CREATED, new Date());
        return generateToken(claims);
    }

    /**
     * 判断token是否可以被刷新
     */
    public boolean canRefresh(String token) {
        return !isTokenExpired(token);
    }

    /**
     * 刷新token
     */
    public String refreshToken(String token) {
        Claims claims = getClaimsFromToken(token);
        claims.put(CLAIM_KEY_CREATED, new Date());
        return generateToken(claims);
    }
}
Copy to clipboardErrorCopied
添加SpringSecurity的配置类
package com.macro.mall.tiny.config;

import com.macro.mall.tiny.component.JwtAuthenticationTokenFilter;
import com.macro.mall.tiny.component.RestAuthenticationEntryPoint;
import com.macro.mall.tiny.component.RestfulAccessDeniedHandler;
import com.macro.mall.tiny.dto.AdminUserDetails;
import com.macro.mall.tiny.mbg.model.UmsAdmin;
import com.macro.mall.tiny.mbg.model.UmsPermission;
import com.macro.mall.tiny.service.UmsAdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.util.List;


/**
 * SpringSecurity的配置
 * Created by macro on 2018/4/26.
 */
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled=true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Autowired
    private UmsAdminService adminService;
    @Autowired
    private RestfulAccessDeniedHandler restfulAccessDeniedHandler;
    @Autowired
    private RestAuthenticationEntryPoint restAuthenticationEntryPoint;

    @Override
    protected void configure(HttpSecurity httpSecurity) throws Exception {
        httpSecurity.csrf()// 由于使用的是JWT，我们这里不需要csrf
                .disable()
                .sessionManagement()// 基于token，所以不需要session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .antMatchers(HttpMethod.GET, // 允许对于网站静态资源的无授权访问
                        "/",
                        "/*.html",
                        "/favicon.ico",
                        "/**/*.html",
                        "/**/*.css",
                        "/**/*.js",
                        "/swagger-resources/**",
                        "/v2/api-docs/**"
                )
                .permitAll()
                .antMatchers("/admin/login", "/admin/register")// 对登录注册要允许匿名访问
                .permitAll()
                .antMatchers(HttpMethod.OPTIONS)//跨域请求会先进行一次options请求
                .permitAll()
//                .antMatchers("/**")//测试时全部运行访问
//                .permitAll()
                .anyRequest()// 除上面外的所有请求全部需要鉴权认证
                .authenticated();
        // 禁用缓存
        httpSecurity.headers().cacheControl();
        // 添加JWT filter
        httpSecurity.addFilterBefore(jwtAuthenticationTokenFilter(), UsernamePasswordAuthenticationFilter.class);
        //添加自定义未授权和未登录结果返回
        httpSecurity.exceptionHandling()
                .accessDeniedHandler(restfulAccessDeniedHandler)
                .authenticationEntryPoint(restAuthenticationEntryPoint);
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService())
                .passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        //获取登录用户信息
        return username -> {
            UmsAdmin admin = adminService.getAdminByUsername(username);
            if (admin != null) {
                List<UmsPermission> permissionList = adminService.getPermissionList(admin.getId());
                return new AdminUserDetails(admin,permissionList);
            }
            throw new UsernameNotFoundException("用户名或密码错误");
        };
    }

    @Bean
    public JwtAuthenticationTokenFilter jwtAuthenticationTokenFilter(){
        return new JwtAuthenticationTokenFilter();
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

}
Copy to clipboardErrorCopied
相关依赖及方法说明

configure(HttpSecurity httpSecurity)：用于配置需要拦截的url路径、jwt过滤器及出异常后的处理器；
configure(AuthenticationManagerBuilder auth)：用于配置UserDetailsService及PasswordEncoder；
RestfulAccessDeniedHandler：当用户没有访问权限时的处理器，用于返回JSON格式的处理结果；
RestAuthenticationEntryPoint：当未登录或token失效时，返回JSON格式的结果；
UserDetailsService:SpringSecurity定义的核心接口，用于根据用户名获取用户信息，需要自行实现；
UserDetails：SpringSecurity定义用于封装用户信息的类（主要是用户信息和权限），需要自行实现；
PasswordEncoder：SpringSecurity定义的用于对密码进行编码及比对的接口，目前使用的是BCryptPasswordEncoder；
JwtAuthenticationTokenFilter：在用户名和密码校验前添加的过滤器，如果有jwt的token，会自行根据token信息进行登录。
添加RestfulAccessDeniedHandler
package com.macro.mall.tiny.component;

import cn.hutool.json.JSONUtil;
import com.macro.mall.tiny.common.api.CommonResult;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 当访问接口没有权限时，自定义的返回结果
 * Created by macro on 2018/4/26.
 */
@Component
public class RestfulAccessDeniedHandler implements AccessDeniedHandler{
    @Override
    public void handle(HttpServletRequest request,
                       HttpServletResponse response,
                       AccessDeniedException e) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.getWriter().println(JSONUtil.parse(CommonResult.forbidden(e.getMessage())));
        response.getWriter().flush();
    }
}
Copy to clipboardErrorCopied
添加RestAuthenticationEntryPoint
package com.macro.mall.tiny.component;

import cn.hutool.json.JSONUtil;
import com.macro.mall.tiny.common.api.CommonResult;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 当未登录或者token失效访问接口时，自定义的返回结果
 * Created by macro on 2018/5/14.
 */
@Component
public class RestAuthenticationEntryPoint implements AuthenticationEntryPoint {
    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.getWriter().println(JSONUtil.parse(CommonResult.unauthorized(authException.getMessage())));
        response.getWriter().flush();
    }
}
Copy to clipboardErrorCopied
添加AdminUserDetails
package com.macro.mall.tiny.dto;

import com.macro.mall.tiny.mbg.model.UmsAdmin;
import com.macro.mall.tiny.mbg.model.UmsPermission;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * SpringSecurity需要的用户详情
 * Created by macro on 2018/4/26.
 */
public class AdminUserDetails implements UserDetails {
    private UmsAdmin umsAdmin;
    private List<UmsPermission> permissionList;
    public AdminUserDetails(UmsAdmin umsAdmin, List<UmsPermission> permissionList) {
        this.umsAdmin = umsAdmin;
        this.permissionList = permissionList;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        //返回当前用户的权限
        return permissionList.stream()
                .filter(permission -> permission.getValue()!=null)
                .map(permission ->new SimpleGrantedAuthority(permission.getValue()))
                .collect(Collectors.toList());
    }

    @Override
    public String getPassword() {
        return umsAdmin.getPassword();
    }

    @Override
    public String getUsername() {
        return umsAdmin.getUsername();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return umsAdmin.getStatus().equals(1);
    }
}
Copy to clipboardErrorCopied
添加JwtAuthenticationTokenFilter
在用户名和密码校验前添加的过滤器，如果请求中有jwt的token且有效，会取出token中的用户名，然后调用SpringSecurity的API进行登录操作。

package com.macro.mall.tiny.component;

import com.macro.mall.tiny.common.utils.JwtTokenUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * JWT登录授权过滤器
 * Created by macro on 2018/4/26.
 */
public class JwtAuthenticationTokenFilter extends OncePerRequestFilter {
    private static final Logger LOGGER = LoggerFactory.getLogger(JwtAuthenticationTokenFilter.class);
    @Autowired
    private UserDetailsService userDetailsService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Value("${jwt.tokenHeader}")
    private String tokenHeader;
    @Value("${jwt.tokenHead}")
    private String tokenHead;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        String authHeader = request.getHeader(this.tokenHeader);
        if (authHeader != null && authHeader.startsWith(this.tokenHead)) {
            String authToken = authHeader.substring(this.tokenHead.length());// The part after "Bearer "
            String username = jwtTokenUtil.getUserNameFromToken(authToken);
            LOGGER.info("checking username:{}", username);
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);
                if (jwtTokenUtil.validateToken(authToken, userDetails)) {
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    LOGGER.info("authenticated user:{}", username);
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
            }
        }
        chain.doFilter(request, response);
    }
}






mall整合SpringSecurity和JWT实现认证和授权（二）

接上一篇，controller和service层的代码实现及登录授权流程演示。

登录注册功能实现
添加UmsAdminController类
实现了后台用户登录、注册及获取权限的接口

package com.macro.mall.tiny.controller;

import com.macro.mall.tiny.common.api.CommonResult;
import com.macro.mall.tiny.dto.UmsAdminLoginParam;
import com.macro.mall.tiny.mbg.model.UmsAdmin;
import com.macro.mall.tiny.mbg.model.UmsPermission;
import com.macro.mall.tiny.service.UmsAdminService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台用户管理
 * Created by macro on 2018/4/26.
 */
@Controller
@Api(tags = "UmsAdminController", description = "后台用户管理")
@RequestMapping("/admin")
public class UmsAdminController {
    @Autowired
    private UmsAdminService adminService;
    @Value("${jwt.tokenHeader}")
    private String tokenHeader;
    @Value("${jwt.tokenHead}")
    private String tokenHead;

    @ApiOperation(value = "用户注册")
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    @ResponseBody
    public CommonResult<UmsAdmin> register(@RequestBody UmsAdmin umsAdminParam, BindingResult result) {
        UmsAdmin umsAdmin = adminService.register(umsAdminParam);
        if (umsAdmin == null) {
            CommonResult.failed();
        }
        return CommonResult.success(umsAdmin);
    }

    @ApiOperation(value = "登录以后返回token")
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody
    public CommonResult login(@RequestBody UmsAdminLoginParam umsAdminLoginParam, BindingResult result) {
        String token = adminService.login(umsAdminLoginParam.getUsername(), umsAdminLoginParam.getPassword());
        if (token == null) {
            return CommonResult.validateFailed("用户名或密码错误");
        }
        Map<String, String> tokenMap = new HashMap<>();
        tokenMap.put("token", token);
        tokenMap.put("tokenHead", tokenHead);
        return CommonResult.success(tokenMap);
    }

    @ApiOperation("获取用户所有权限（包括+-权限）")
    @RequestMapping(value = "/permission/{adminId}", method = RequestMethod.GET)
    @ResponseBody
    public CommonResult<List<UmsPermission>> getPermissionList(@PathVariable Long adminId) {
        List<UmsPermission> permissionList = adminService.getPermissionList(adminId);
        return CommonResult.success(permissionList);
    }
}
Copy to clipboardErrorCopied
添加UmsAdminService接口
package com.macro.mall.tiny.service;

import com.macro.mall.tiny.mbg.model.UmsAdmin;
import com.macro.mall.tiny.mbg.model.UmsPermission;

import java.util.List;

/**
 * 后台管理员Service
 * Created by macro on 2018/4/26.
 */
public interface UmsAdminService {
    /**
     * 根据用户名获取后台管理员
     */
    UmsAdmin getAdminByUsername(String username);

    /**
     * 注册功能
     */
    UmsAdmin register(UmsAdmin umsAdminParam);

    /**
     * 登录功能
     * @param username 用户名
     * @param password 密码
     * @return 生成的JWT的token
     */
    String login(String username, String password);

    /**
     * 获取用户所有权限（包括角色权限和+-权限）
     */
    List<UmsPermission> getPermissionList(Long adminId);
}
Copy to clipboardErrorCopied
添加UmsAdminServiceImpl类
package com.macro.mall.tiny.service.impl;

import com.macro.mall.tiny.common.utils.JwtTokenUtil;
import com.macro.mall.tiny.dao.UmsAdminRoleRelationDao;
import com.macro.mall.tiny.dto.UmsAdminLoginParam;
import com.macro.mall.tiny.mbg.mapper.UmsAdminMapper;
import com.macro.mall.tiny.mbg.model.UmsAdmin;
import com.macro.mall.tiny.mbg.model.UmsAdminExample;
import com.macro.mall.tiny.mbg.model.UmsPermission;
import com.macro.mall.tiny.service.UmsAdminService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * UmsAdminService实现类
 * Created by macro on 2018/4/26.
 */
@Service
public class UmsAdminServiceImpl implements UmsAdminService {
    private static final Logger LOGGER = LoggerFactory.getLogger(UmsAdminServiceImpl.class);
    @Autowired
    private UserDetailsService userDetailsService;
    @Autowired
    private JwtTokenUtil jwtTokenUtil;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Value("${jwt.tokenHead}")
    private String tokenHead;
    @Autowired
    private UmsAdminMapper adminMapper;
    @Autowired
    private UmsAdminRoleRelationDao adminRoleRelationDao;

    @Override
    public UmsAdmin getAdminByUsername(String username) {
        UmsAdminExample example = new UmsAdminExample();
        example.createCriteria().andUsernameEqualTo(username);
        List<UmsAdmin> adminList = adminMapper.selectByExample(example);
        if (adminList != null && adminList.size() > 0) {
            return adminList.get(0);
        }
        return null;
    }

    @Override
    public UmsAdmin register(UmsAdmin umsAdminParam) {
        UmsAdmin umsAdmin = new UmsAdmin();
        BeanUtils.copyProperties(umsAdminParam, umsAdmin);
        umsAdmin.setCreateTime(new Date());
        umsAdmin.setStatus(1);
        //查询是否有相同用户名的用户
        UmsAdminExample example = new UmsAdminExample();
        example.createCriteria().andUsernameEqualTo(umsAdmin.getUsername());
        List<UmsAdmin> umsAdminList = adminMapper.selectByExample(example);
        if (umsAdminList.size() > 0) {
            return null;
        }
        //将密码进行加密操作
        String encodePassword = passwordEncoder.encode(umsAdmin.getPassword());
        umsAdmin.setPassword(encodePassword);
        adminMapper.insert(umsAdmin);
        return umsAdmin;
    }

    @Override
    public String login(String username, String password) {
        String token = null;
        try {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            if (!passwordEncoder.matches(password, userDetails.getPassword())) {
                throw new BadCredentialsException("密码不正确");
            }
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(authentication);
            token = jwtTokenUtil.generateToken(userDetails);
        } catch (AuthenticationException e) {
            LOGGER.warn("登录异常:{}", e.getMessage());
        }
        return token;
    }


    @Override
    public List<UmsPermission> getPermissionList(Long adminId) {
        return adminRoleRelationDao.getPermissionList(adminId);
    }
}
Copy to clipboardErrorCopied
修改Swagger的配置
通过修改配置实现调用接口自带Authorization头，这样就可以访问需要登录的接口了。

package com.macro.mall.tiny.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.ArrayList;
import java.util.List;

/**
 * Swagger2API文档的配置
 */
@Configuration
@EnableSwagger2
public class Swagger2Config {
    @Bean
    public Docket createRestApi(){
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                //为当前包下controller生成API文档
                .apis(RequestHandlerSelectors.basePackage("com.macro.mall.tiny.controller"))
                .paths(PathSelectors.any())
                .build()
                //添加登录认证
                .securitySchemes(securitySchemes())
                .securityContexts(securityContexts());
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("SwaggerUI演示")
                .description("mall-tiny")
                .contact("macro")
                .version("1.0")
                .build();
    }

    private List<ApiKey> securitySchemes() {
        //设置请求头信息
        List<ApiKey> result = new ArrayList<>();
        ApiKey apiKey = new ApiKey("Authorization", "Authorization", "header");
        result.add(apiKey);
        return result;
    }

    private List<SecurityContext> securityContexts() {
        //设置需要登录认证的路径
        List<SecurityContext> result = new ArrayList<>();
        result.add(getContextByPath("/brand/.*"));
        return result;
    }

    private SecurityContext getContextByPath(String pathRegex){
        return SecurityContext.builder()
                .securityReferences(defaultAuth())
                .forPaths(PathSelectors.regex(pathRegex))
                .build();
    }

    private List<SecurityReference> defaultAuth() {
        List<SecurityReference> result = new ArrayList<>();
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        result.add(new SecurityReference("Authorization", authorizationScopes));
        return result;
    }
}
Copy to clipboardErrorCopied
给PmsBrandController接口中的方法添加访问权限
给查询接口添加pms:brand:read权限
给修改接口添加pms:brand:update权限
给删除接口添加pms:brand:delete权限
给添加接口添加pms:brand:create权限
例子：

@PreAuthorize("hasAuthority('pms:brand:read')")
public CommonResult<List<PmsBrand>> getBrandList() {
    return CommonResult.success(brandService.listAllBrand());
}

eyJ2IjoibE1QdDRqdVhPVDJpZTdNMlk0ai9Mdz09IiwidCI6IklWZ282MzV2eXEvUDNzd01kUDJyM3U1V2ZjVkdjTkN2bWUxL0cvNmQ2MTQ9IiwibSI6IjBhMGRiZjZiYWI0Mzg4NTI0ZTA0NWNmZTc2YmUwYjQxMTNhYzNjYTBhZGUzMDhlZTU4MmJhNjljZTI4ZmVhYTcifQ==

參考資料：
https://github.com/Sky24n/flutter_wanandroid

Flutter 多渠道打包实践
https://juejin.cn/post/6844904110597259272



地址轉緯度

1.真實地點及經緯度 -- 格上總部  地址：台北市中山區濱江街309號5樓 25.0725068,121.5441013
geocode API 執行結果(經緯度轉地址)：
google: 25.0725021,121.5462897
圖霸:    25.0725577,121.5462944

2.真實地點及經緯度 --新店行遍天下站  地址：新北市新店區中興路三段3號B1樓A棟 24.9778085,121.5432163
geocode 執行結果(經緯度轉地址)：
google: 24.976919,121.545983
圖霸:    24.977372,121.545755

3.真實地點及經緯度 --台北火車站 地址：台北市中正區北平西路3號 25.0467363,121.5143109 
geocode  執行結果(經緯度轉地址)：
google: 24.976919,121.545983
圖霸: 25.047173,121.51705

4.真實地點及經緯度 --國立故宮博物院   25.1023602,121.5463038 地址：台北市士林區至善路二段221號
geocode 執行結果(經緯度轉地址)：
google:  25.1004265,121.5498091
圖霸:     25.100367,121.5494955

5.真實地點及經緯度 --漁人碼頭停車場  地址：新北市淡水區觀海路91號 25.183009,121.409321 
geocode 執行結果(經緯度轉地址)：
google:  25.1835935,121.4142916
圖霸:  25.1828884182,121.414322266

6.真實地點及經緯度 --陽明山國家公園遊客中心  地址：台北市北投區竹子湖路1-20號 25.1553525,121.5444123 
geocode 執行結果(經緯度轉地址)：
google:   25.15568,121.5476786
圖霸:      25.15536,121.546532


7.真實地點及經緯度 --士林夜市   地址：台北市士林區中山北路五段65號 25.0894193,121.5091652
geocode 執行結果(經緯度轉地址)：
google: 25.084873,121.525078
圖霸:    25.083559,121.52515

8.真實地點及經緯度 --福德坑  地址：台北市文山區木柵路五段151號 24.9990739,121.5912147 
geocode 執行結果(經緯度轉地址)：
google:  24.9989605,121.5938041
圖霸:     25.0074068,121.589314


9.真實地點及經緯度 --新竹市立動物園  地址：新竹市東區食品路66號 24.8001508,120.9777424 
geocode 執行結果(經緯度轉地址)：
google: 24.798897,120.9788137
圖霸:  24.8003946154,120.97911618

10.真實地點及經緯度 --宜蘭車站  地址：260宜蘭縣宜蘭市光復路1號 24.7546483,121.7558589 
geocode 執行結果(經緯度轉地址)：
google: 24.7546434,121.7580476
圖霸: 24.7545837808,121.758020568

反向geocode結果 總結
這部份兩者差距不大。








1.真實地點及經緯度 -- 格上總部  25.0725068,121.5441013 地址：台北市中山區濱江街309號5樓
geocode API 執行結果(經緯度轉地址)：
google: 台灣台北市中山區濱江街289號
圖霸: 台北市中山區濱江街287號
勤崴: 台北市中山區濱江街287號


2.真實地點及經緯度 --新店行遍天下站 24.9778085,121.5432163 地址：新北市新店區中興路三段3號B1樓A棟
geocode 執行結果(經緯度轉地址)：
google: 台灣新北市新店區寶橋路85巷250號
圖霸: 新北市新店區北新路二段250號
勤崴: 新北市新店區北新路二段252號

3.真實地點及經緯度 --台北火車站 25.0467363,121.5143109 地址：台北市中正區北平西路3號100臺灣
geocode  執行結果(經緯度轉地址)：
google: 台灣台北市中正區忠孝西路一段70號
圖霸: 台北市中正區忠孝西路一段70號
勤崴: 台北市中正區忠孝西路一段70之3號

4.真實地點及經緯度 --國立故宮博物院  25.1023602,121.5463038 地址：台北市士林區至善路二段221號
geocode 執行結果(經緯度轉地址)：
google: 台灣台北市士林區至善路二段113巷35弄21號
圖霸: 台北市士林區至善路二段113巷81弄9號
勤崴: 台北市士林區至善路二段113巷35弄21號

5.真實地點及經緯度 --漁人碼頭停車場  25.183009,121.409321 地址：新北市淡水區觀海路91號
geocode 執行結果(經緯度轉地址)：
google: 台灣新北市淡水區觀海路199號
圖霸: 新北市淡水區其他道路
勤崴: 新北市淡水區觀海路251號

6.真實地點及經緯度 --陽明山國家公園遊客中心  25.1553525,121.5444123 地址：台北市北投區竹子湖路1-20號
geocode 執行結果(經緯度轉地址)：
google: 台灣台北市北投區竹子湖路1-11號
圖霸: 台北市北投區竹子湖路1之11號
勤崴: 台北市北投區竹子湖路1之11號


7.真實地點及經緯度 --士林夜市  25.0894193,121.5091652 地址：台北市士林區中山北路五段65號
geocode 執行結果(經緯度轉地址)：
google: 台灣台北市士林區延平北路六段116巷2弄41號
圖霸: 台北市士林區延平北路六段116巷2弄41號
勤崴: 台北市士林區延平北路六段116巷2弄41號

8.真實地點及經緯度 --福德坑  24.9990739,121.5912147 地址：台北市文山區木柵路五段151號
geocode 執行結果(經緯度轉地址)：
google: 台灣台北市文山區木柵路五段100號之3號
圖霸: 台北市文山區木柵路五段162號
勤崴: 台北市文山區木柵路五段162號


9.真實地點及經緯度 --新竹市立動物園  24.8001508,120.9777424 地址：300新竹市東區食品路66號
geocode 執行結果(經緯度轉地址)：
google: 台灣新竹市東區公園路289號
圖霸: 新竹市東區公園路299號
勤崴: 新竹市東區公園路299號

10.真實地點及經緯度 --宜蘭車站  24.7546483,121.7558589 地址：260宜蘭縣宜蘭市光復路1號26043
geocode 執行結果(經緯度轉地址)：
google: 台灣宜蘭縣宜蘭市光復路41號
圖霸: 宜蘭縣宜蘭市光復路41號
勤崴: 宜蘭縣宜蘭市光復路41號

geocode結果 總結
除第5.項 --漁人碼頭停車場的部份。（圖霸找出的位置：新北市淡水區其他道路外）（google: 台灣新北市淡水區觀海路199號 勤崴: 新北市淡水區觀海路251號）有不同外其他大致相同


google-地點自動完成 API
第一個
1.輪入座標點 25.072502,121.544096 （為格上總公司）
2.結果place_id -- 格上 geocode "place_id": "ChIJN_d2cPirQjQRe5Ll-qZL4FM" 圖霸-"place_id": "NzYqAQYCRxoGW1hTIBlmVg9LPjttWVt5L1lPWQhYKSMmFDZHGUUgEg=="
autocomplete API 執行結果(經緯度轉地址)：
google: 1.格上汽車租賃股份有限公司 (台北總公司) 2.格上租車 台北內湖站 3.格上租車 台北忠孝站/納智捷體驗站
圖霸:    1.格上租車台北總公司 2.格上租車台北松山機場站 3.格上租車劍潭捷運站
第二個
1.輪入座標點 -- 松山 25.072502,121.544096（為格上總公司）｜
2.結果place_id -- 松山機場 geocode "place_id": "ChIJWSYUpPGrQjQROop1ttwNGJM", 圖霸-"place_id": "NzYqAQYARB0BW1JTLgd1DBdOAyRrHTxfEThuRVVDTCtSM0JqQUEsEg=="
autocomplete API 執行結果(經緯度轉地址)：
google: 1.松山機場 2.松山文創園區 3.松山車站
圖霸:    1.松山堤防旁停車場一 2.松山堤防旁停車場二 3.松山堤防旁停車場三

第三個
1.輪入座標點 -- 圓山 25.0789068,121.5244107（為圓山大飯店）｜
2.結果place_id -- 圓山大飯店 geocode ""place_id": "ChIJ8yTxWq2uQjQRPx2hN4IMZ-Y", 圖霸-place_id": "NzYqAQYCRxwDWVpTEl98JEwDTg9Af15yAC5zcnJ8Kg0pDTNVYnFNEg=="
autocomplete API 執行結果(經緯度轉地址)：
google: 1.圓山大飯店 2.圓山轉運站 3.圓山爭艷館
圖霸:    1.圓山大飯店 2.圓山迎春風 3.圓山小吃店

第四個
1.輪入座標點 -- 故宮 25.1023602,121.5463038（為國立故宮博物院）
2.結果place_id -- 國立故宮博物院 geocode "place_id": "ChIJfUpAzTqsQjQRwQl6ORhwbV0", 圖霸-"place_id": "NzYqAQYHTBcEWFpTHCcPBRNBOBpYAhgCQAxdWkoNPjA/TSEEV3AgEg=="
autocomplete API 執行結果(經緯度轉地址)：
google: 1.故宮博物院 2.故宮晶華 3.故宮路
圖霸:    1.故宮西側停車場 2.故宮東側停車場 3.故宮博物院後樂園


第五個

1.輪入座標點 -- 臺北車站 25.0477068,121.5151848（為臺北車站）
2.結果place_id -- 臺北車站 geocode "place_id": "ChIJCZEzfnKpQjQRy75KOs4xSsM", 圖霸-"place_id": "NzYqAQYCRxcGXl5TLl9nCQAeVhBqWDtkJC5dAFtlXg5TQUB5dEZFEg=="
autocomplete API 執行結果(經緯度轉地址)：
google: 1.臺北車站 2.臺北車站 3.臺北車站
圖霸:    1.台北火車站 2.桃園捷運台北車站A1 3.台北車站西地下停車場


地點詳細資訊
第一個
1.輸入place_id -- 格上總公司 geocode "place_id": "ChIJN_d2cPirQjQRe5Ll-qZL4FM" 圖霸-"place_id": "NzYqAQYCRxoGW1hTIBlmVg9LPjttWVt5L1lPWQhYKSMmFDZHGUUgEg=="
place/details API 執行結果(地點詳細資訊)：
google:   {
              "html_attributions": [],
              "result": {
                  "formatted_address": "104台灣台北市中山區濱江街309號5樓",
                  "formatted_phone_number": "02 2518 3060",
                  "geometry": {
                      "location": {
                          "lat": 25.072502,
                          "lng": 121.54629
                      },
                      "viewport": {
                          "northeast": {
                              "lat": 25.0737681802915,
                              "lng": 121.5476370302915
                          },
                          "southwest": {
                              "lat": 25.07107021970849,
                              "lng": 121.5449390697085
                          }
                      }
                  },
                  "name": "格上汽車租賃股份有限公司 (台北總公司)",
                  "place_id": "ChIJN_d2cPirQjQRe5Ll-qZL4FM",
                  "rating": 4.2
              },
              "status": "OK"
          }
          
圖霸:        "result": {
               "formatted_address": "台北市中山區濱江街309號5樓",
               "geometry": {
                   "location": {
                       "lat": 25.072558,
                       "lng": 121.546294
                   }
               },
               "id": "NzYqAQYCRxoGW1hTIBlmVg9LPjttWVt5L1lPWQhYKSMmFDZHGUUgEg==",
               "place_id": "NzYqAQYCRxoGW1hTIBlmVg9LPjttWVt5L1lPWQhYKSMmFDZHGUUgEg==",
               "name": "格上租車台北總公司",
               "tel": "02-25183060",
               "city": "台北市",
               "town": "中山區",
               "type": "地點",
               "chain": "格上租車",
               "branch": "台北總公司",
               "cat": "租車公司",
               "postcode": "104"
           }

第二個
1.輸入place_id -- 松山機場 geocode "place_id": "ChIJWSYUpPGrQjQROop1ttwNGJM", 圖霸-"place_id": "NzYqAQYARB0BW1JTLgd1DBdOAyRrHTxfEThuRVVDTCtSM0JqQUEsEg=="
place/details API 執行結果(地點詳細資訊)：
google: 1.{
              "html_attributions": [],
              "result": {
                  "formatted_address": "10548台灣台北市松山區敦化北路340-9號",
                  "formatted_phone_number": "02 8770 3460",
                  "geometry": {
                      "location": {
                          "lat": 25.067566,
                          "lng": 121.552699
                      },
                      "viewport": {
                          "northeast": {
                              "lat": 25.07023215,
                              "lng": 121.5533861302915
                          },
                          "southwest": {
                              "lat": 25.05956755,
                              "lng": 121.5506881697085
                          }
                      }
                  },
                  "name": "臺北松山機場",
                  "place_id": "ChIJWSYUpPGrQjQROop1ttwNGJM",
                  "rating": 4.3
              },
              "status": "OK"
          }
圖霸:    1."result": {
                 "formatted_address": "台北市中山區濱江街309號5樓",
                 "geometry": {
                     "location": {
                         "lat": 25.072558,
                         "lng": 121.546294
                     }
                 },
                 "id": "NzYqAQYCRxoGW1hTIBlmVg9LPjttWVt5L1lPWQhYKSMmFDZHGUUgEg==",
                 "place_id": "NzYqAQYCRxoGW1hTIBlmVg9LPjttWVt5L1lPWQhYKSMmFDZHGUUgEg==",
                 "name": "格上租車台北總公司",
                 "tel": "02-25183060",
                 "city": "台北市",
                 "town": "中山區",
                 "type": "地點",
                 "chain": "格上租車",
                 "branch": "台北總公司",
                 "cat": "租車公司",
                 "postcode": "104"
             },


第三個｜
1.輸入place_id place_id -- 圓山大飯店 geocode ""place_id": "ChIJ8yTxWq2uQjQRPx2hN4IMZ-Y", 圖霸-place_id": "NzYqAQYCRxwDWVpTEl98JEwDTg9Af15yAC5zcnJ8Kg0pDTNVYnFNEg=="
place/details API 執行結果(地點詳細資訊)：
google: 1."result": {
                  "formatted_address": "10461台灣台北市中山區中山北路四段1號",
                  "formatted_phone_number": "02 2886 8888",
                  "geometry": {
                      "location": {
                          "lat": 25.0789127,
                          "lng": 121.5265198
                      },
                      "viewport": {
                          "northeast": {
                              "lat": 25.0799520302915,
                              "lng": 121.5278897302915
                          },
                          "southwest": {
                              "lat": 25.07725406970849,
                              "lng": 121.5251917697085
                          }
                      }
                  },
                  "name": "圓山大飯店",
                  "place_id": "ChIJ8yTxWq2uQjQRPx2hN4IMZ-Y",
                  "rating": 4.4
              },
圖霸:    1.    "result": {
                 "formatted_address": "台北市中山區中山北路四段1號",
                 "geometry": {
                     "location": {
                         "lat": 25.077152,
                         "lng": 121.525677
                     }
                 },
                 "id": "NzYqAQYCRxwDWVpTEl98JEwDTg9Af15yAC5zcnJ8Kg0pDTNVYnFNEg==",
                 "place_id": "NzYqAQYCRxwDWVpTEl98JEwDTg9Af15yAC5zcnJ8Kg0pDTNVYnFNEg==",
                 "name": "圓山大飯店",
                 "tel": "02-28868888",
                 "city": "台北市",
                 "town": "中山區",
                 "type": "地點",
                 "chain": "",
                 "branch": "",
                 "cat": "飯店旅館",
                 "postcode": "104"
             }


第四個
1.輸入place_id -- 國立故宮博物院 geocode "place_id": "ChIJfUpAzTqsQjQRwQl6ORhwbV0", 圖霸-"place_id": "NzYqAQYHTBcEWFpTHCcPBRNBOBpYAhgCQAxdWkoNPjA/TSEEV3AgEg=="
place/details API 執行結果(地點詳細資訊)：
google: 1."result": {
                  "formatted_address": "111台灣台北市士林區至善路二段221號",
                  "formatted_phone_number": "02 2881 2021",
                  "geometry": {
                      "location": {
                          "lat": 25.1023554,
                          "lng": 121.5484925
                      },
                      "viewport": {
                          "northeast": {
                              "lat": 25.10342415,
                              "lng": 121.5506876
                          },
                          "southwest": {
                              "lat": 25.09914915,
                              "lng": 121.5477608
                          }
                      }
                  },
                  "name": "國立故宮博物院",
                  "place_id": "ChIJfUpAzTqsQjQRwQl6ORhwbV0",
                  "rating": 4.5
圖霸:    1.   "result": {
                 "formatted_address": "台北市士林區至善路二段221號",
                 "geometry": {
                     "location": {
                         "lat": 25.10206,
                         "lng": 121.548657
                     }
                 },
                 "id": "NzYqAQYHTBcEWFpTHCcPBRNBOBpYAhgCQAxdWkoNPjA/TSEEV3AgEg==",
                 "place_id": "NzYqAQYHTBcEWFpTHCcPBRNBOBpYAhgCQAxdWkoNPjA/TSEEV3AgEg==",
                 "name": "故宮博物院第一展覽區",
                 "tel": "02-29393091",
                 "city": "台北市",
                 "town": "士林區",
                 "type": "地點",
                 "chain": "",
                 "branch": "",
                 "cat": "藝文美術",
                 "postcode": "111"
             }

第五個

1.輸入place_id -- 臺北車站 geocode "place_id": "ChIJCZEzfnKpQjQRy75KOs4xSsM", 圖霸-"place_id": "NzYqAQYCRxkGXl5TIAdAPiFMEhxQXCRkDhsEUHsBAD42DRJ+cQE8Eg=="
place/details API 執行結果(地點詳細資訊)：
google: 1.    "result": {
                  "formatted_address": "100台灣台北市中正區北平西路3號100臺灣",
                  "formatted_phone_number": "02 2371 3558",
                  "geometry": {
                      "location": {
                          "lat": 25.047702,
                          "lng": 121.5173735
                      },
                      "viewport": {
                          "northeast": {
                              "lat": 25.04950125,
                              "lng": 121.5187948
                          },
                          "southwest": {
                              "lat": 25.04550985000001,
                              "lng": 121.5154096
                          }
                      }
                  },
                  "name": "臺北車站",
                  "place_id": "ChIJCZEzfnKpQjQRy75KOs4xSsM",
                  "rating": 4.2
              }
圖霸:    1.    "result": {
                 "formatted_address": "台北市中正區黎明里北平西路3號",
                 "geometry": {
                     "location": {
                         "lat": 25.047884,
                         "lng": 121.516347
                     }
                 },
                 "id": "NzYqAQYCRxcGXl5TLl9nCQAeVhBqWDtkJC5dAFtlXg5TQUB5dEZFEg==",
                 "place_id": "NzYqAQYCRxcGXl5TLl9nCQAeVhBqWDtkJC5dAFtlXg5TQUB5dEZFEg==",
                 "name": "台北火車站",
                 "tel": "02-23110121",
                 "city": "台北市",
                 "town": "中正區",
                 "type": "地點",
                 "chain": "",
                 "branch": "",
                 "cat": "火車站",
                 "postcode": "100"
             }


路線規化部分
1.格上總部到臺北車站
goole https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyBNeFrRGtXRjJdVuPBonBeWScsQn3WpIIk&language=zh-TW&mode=car&alternatives=true&departure_time=now&origin=25.072502,121.544096&destination=25.047702,121.5173735
結果：  "distance": {
                           "text": "7.2 公里",
                           "value": 7177
                       },
                       "duration": {
                           "text": "14 分鐘",
                           "value": 821
                       },
                       "duration_in_traffic": {
                           "text": "13 分鐘",
                           "value": 788
                       }
https://api.map8.zone/route/car/121.544096,25.072502;121.5173735,25.047702.json                       
圖霸:  "duration":          "legs": [
                                 {
                                     "steps": [],
                                     "distance": 5321,
                                     "duration": 781,
                                     "summary": "民族東路, 林森北路"
                                 }
                             ],
                             "distance": 5321(5.3公里),
                             "duration": 781（13分）

https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.072502,121.544096&destination=25.047702,121.5173735
勤崴:        "legs":{
                    "distance": {
                        "text": "5.4 公里",
                        "value": 5420
                    },
                    "duration": {
                        "text": "12 分鐘",
                        "value": 735
                    },
                    "startAddress": "台北市中山區濱江街282號",
                    "startLocation": {
                        "lat": 25.07240725385538,
                        "lng": 121.54408261955733
                    },
                    "endAddress": "台北市中正區市民大道一段100號",
                    "endLocation": {
                        "lat": 25.04848761208004,
                        "lng": 121.51750607118531
                    },
                    
2.格上總部到林口長庚
goole https://www.google.com/maps/dir/%E5%8F%B0%E5%8C%97%E5%B8%82%E4%B8%AD%E5%B1%B1%E5%8D%80%E6%BF%B1%E6%B1%9F%E8%A1%975%E6%A8%93%E6%A0%BC%E4%B8%8A%E6%B1%BD%E8%BB%8A%E7%A7%9F%E8%B3%83%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8+(%E5%8F%B0%E5%8C%97%E7%B8%BD%E5%85%AC%E5%8F%B8)/333%E6%A1%83%E5%9C%92%E5%B8%82%E9%BE%9C%E5%B1%B1%E5%8D%80%E5%BE%A9%E8%88%88%E8%A1%975%E8%99%9F%E6%9E%97%E5%8F%A3%E9%95%B7%E5%BA%9A%E7%B4%80%E5%BF%B5%E9%86%AB%E9%99%A2/@25.0669942,121.386282,12z/data=!3m1!4b1!4m13!4m12!1m5!1m1!1s0x3442abf87076f737:0x53e04ba6fae5927b!2m2!1d121.54629!2d25.072502!1m5!1m1!1s0x34681df7efe320bd:0x29c884466965864f!2m2!1d121.367572!2d25.061085
結果：        "distance": {
                             "text": "20.1 公里",
                             "value": 20137
                         },
                         "duration": {
                             "text": "23 分鐘",
                             "value": 1371
                         },
                         "duration_in_traffic": {
                             "text": "23 分鐘",
                             "value": 1395
                         },
https://api.map8.zone/route/car/121.544096,25.072502;121.3653833,25.0610898.json?                       
圖霸:  "duration":      "legs": [
                          {
                              "steps": [],
                              "distance": 19983,
                              "duration": 1355,
                              "summary": "中山高速公路, 中山高速公路"
                          }
                        ],
                           "distance": 19983,（19.98公里）
                           "duration": 1355 (22.5分)

https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.072502,121.544096&destination=25.047702,121.5173735
勤崴: "legs": [
                {
                    "distance": {
                        "text": "19.9 公里",
                        "value": 19921
                    },
                    "duration": {
                        "text": "20 分鐘",
                        "value": 1176
                    },
                    "startAddress": "台北市中山區濱江街282號",
                    "startLocation": {
                        "lat": 25.07240725385538,
                        "lng": 121.54408261955733
                    },
                    "endAddress": "桃園市龜山區文化二路11之3號",
                    "endLocation": {
                        "lat": 25.06099196625351,
                        "lng": 121.36552481732019
                    },

3.基隆市戶政事務到基隆廟口夜市
goole https://www.google.com/maps/dir/%E5%9F%BA%E9%9A%86%E5%B8%82%E4%BF%A1%E7%BE%A9%E5%8D%80%E6%88%B6%E6%94%BF%E4%BA%8B%E5%8B%99%E6%89%80/200%E5%9F%BA%E9%9A%86%E5%B8%82%E4%BB%81%E6%84%9B%E5%8D%80%E6%84%9B%E5%9B%9B%E8%B7%AF20%E8%99%9F%E5%9F%BA%E9%9A%86%E5%BB%9F%E5%8F%A3%E5%A4%9C%E5%B8%82/@25.1267256,121.7526284,15.44z/data=!4m13!4m12!1m5!1m1!1s0x345d4e362f88fb7f:0x6c4fff460e3b385b!2m2!1d121.757571!2d25.1285339!1m5!1m1!1s0x345d4e3e159d9663:0x1d84dd13f992491e!2m2!1d121.7435851!2d25.1283104
結果：          "distance": {
                                   "text": "1.7 公里",
                                   "value": 1688
                               },
                               "duration": {
                                   "text": "7 分鐘",
                                   "value": 398
                               },
                               "duration_in_traffic": {
                                   "text": "6 分鐘",
                                   "value": 356
                               },
https://api.map8.zone/route/car/121.7553823,25.1285387;121.7413964,25.1283152.json?                       
圖霸:  "duration":      "legs": [
                                      {
                                          "steps": [],
                                          "distance": 1685,
                                          "duration": 254,
                                          "summary": "信一路, 仁二路"
                                      }
                                  ],
                                  "distance": 1685(1.7公里),
                                  "duration": 254(4.2分)
                                  
https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.1285387,121.7553823&destination=25.1283152,121.7413964
勤崴:"legs": [
                {
                    "distance": {
                        "text": "1.7 公里",
                        "value": 1664
                    },
                    "duration": {
                        "text": "5 分鐘",
                        "value": 309
                    },
                    "startAddress": "基隆市信義區中興路4巷18號",
                    "startLocation": {
                        "lat": 25.12838433091205,
                        "lng": 121.75538939348769
                    },
                    "endAddress": "基隆市仁愛區愛二路5號",
                    "endLocation": {
                        "lat": 25.128219529422356,
                        "lng": 121.74154473977053
                    },
                    "steps": [

4.臺北市政府到桃園機場
goole https://www.google.com/maps/dir/%E8%87%BA%E5%8C%97%E5%B8%82%E6%94%BF%E5%BA%9C+11008%E5%8F%B0%E5%8C%97%E5%B8%82%E4%BF%A1%E7%BE%A9%E5%8D%80%E5%B8%82%E5%BA%9C%E8%B7%AF1%E8%99%9F/%E8%87%BA%E7%81%A3%E6%A1%83%E5%9C%92%E5%9C%8B%E9%9A%9B%E6%A9%9F%E5%A0%B4+33758%E6%A1%83%E5%9C%92%E5%B8%82%E5%A4%A7%E5%9C%92%E5%8D%80%E8%88%AA%E7%AB%99%E5%8D%97%E8%B7%AF9%E8%99%9F/@25.0517012,121.2538119,11z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x3442abb9dc73545d:0x6513f5fb17ad1f67!2m2!1d121.5644327!2d25.0375417!1m5!1m1!1s0x34429fc062d215d5:0x70a3b690a9b5b109!2m2!1d121.234217!2d25.0796514!3e0
結果：  "distance": "legs": [
                                 {
                                     "distance": {
                                         "text": "47.4 公里",
                                         "value": 47417
                                     },
                                     "duration": {
                                         "text": "40 分鐘",
                                         "value": 2419
                                     },
                                     "duration_in_traffic": {
                                         "text": "40 分鐘",
                                         "value": 2377
                                     },
                                     
https://api.map8.zone/route/car/121.561593,25.0377275;121.2320283,25.0796562.json                       
圖霸:  "duration":             "legs": [
                                          {
                                              "steps": [],
                                              "distance": 47433,
                                              "duration": 3360(56分),
                                              "summary": "中山高速公路, 中山高五楊高架道路"
                                          }
                                      ],
                                      "distance": 47433(47公里),
                                      "duration": 3360（56分）
                                                      
https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.072502,121.544096&destination=25.047702,121.5173735                      
勤崴:  "duration":           "legs": [
                                           {
                                               "distance": {
                                                   "text": "49.3 公里",
                                                   "value": 49311
                                               },
                                               "duration": {
                                                   "text": "42 分鐘",
                                                   "value": 2524
                                               },
                                               "startAddress": "台北市信義區仁愛路四段518號",
                                               "startLocation": {
                                                   "lat": 25.037728945263265,
                                                   "lng": 121.56148936167902
                                               },
                                               "endAddress": "桃園市大園區航站南路11號",
                                               "endLocation": {
                                                   "lat": 25.079054337932593,
                                                   "lng": 121.23260357492502
                                               },
                                               "steps": [                                                     
5.格上行遍到格上總部 
goole https://www.google.com/maps/dir/%E6%96%B0%E5%8C%97%E5%B8%82%E6%96%B0%E5%BA%97%E5%8D%80%E8%A1%8C%E9%81%8D%E5%A4%A9%E4%B8%8B%E5%9C%B0%E4%B8%8B%E5%AE%A4%E5%81%9C%E8%BB%8A%E5%A0%B4/%E5%8F%B0%E5%8C%97%E5%B8%82%E4%B8%AD%E5%B1%B1%E5%8D%80%E6%BF%B1%E6%B1%9F%E8%A1%97%E6%A0%BC%E4%B8%8A%E6%B1%BD%E8%BB%8A%E7%A7%9F%E8%B3%83%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8+(%E5%8F%B0%E5%8C%97%E7%B8%BD%E5%85%AC%E5%8F%B8)/@25.0201563,121.4900618,11.93z/data=!4m14!4m13!1m5!1m1!1s0x346801fa7f81306d:0x763cf5065563dbbe!2m2!1d121.545405!2d24.977794!1m5!1m1!1s0x3442abf87076f737:0x53e04ba6fae5927b!2m2!1d121.54629!2d25.072502!3e0
結果：      "distance": {
                             "text": "14.5 公里",
                             "value": 14514
                         },
                         "duration": {
                             "text": "22 分鐘",
                             "value": 1339
                         },
                         "duration_in_traffic": {
                             "text": "23 分鐘",
                             "value": 1350
                         },
                         
https://api.map8.zone/route/car/121.5432163,24.9777988;121.5441013,25.0725068.json                       
圖霸:  "duration":         "legs": [
                                         {
                                             "steps": [],
                                             "distance": 13815,
                                             "duration": 1646,
                                             "summary": "建國高架道路, 建國高架道路"
                                         }
                                     ],
                                     "distance": 13815（13.8公里）,
                                     "duration": 1646(27.5分)
                                     

https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=24.9777988,121.5432163&destination=25.0725068,121.5441013                      
勤崴:  "duration":         "legs": [
                                         {
                                             "distance": {
                                                 "text": "15.5 公里",
                                                 "value": 15469
                                             },
                                             "duration": {
                                                 "text": "26 分鐘",
                                                 "value": 1551
                                             },
                                             "startAddress": "新北市新店區北新路二段252號",
                                             "startLocation": {
                                                 "lat": 24.977714852068445,
                                                 "lng": 121.54319976750578
                                             },
                                             "endAddress": "台北市中山區濱江街282號",
                                             "endLocation": {
                                                 "lat": 25.072407217525104,
                                                 "lng": 121.54409253180143
                                             },   
                                                                          

地圖總結

geocode API 結果 總結
除第5.項 --漁人碼頭停車場的部份。（圖霸找出的位置：新北市淡水區其他道路外）（google: 台灣新北市淡水區觀海路199號 勤崴: 新北市淡水區觀海路251號）有不同外其他大致相同

autocomplete API 結果 總結
這部份圖霸及google有個自的表示方法。也難說誰好誰不好，勤崴則本身沒這功能？

place/details API 結果 總結
這部份圖霸及google大致結果皆相同。勤崴則本身也沒這功能？

路線規化部分 API 結果 總結
這部份勤崴及google兩者結果比較相似。第4項.臺北市政府到桃園機場，距離相似但時間就多了16分左右，這部份是跟其他兩個有比較大的不同。

全部總結：勤崴及google兩者大致都相似，圖霸是全部項目中有兩項出現的差異。

Epoch & Unix Timestamp Conversion Tools https://www.epochconverter.com                                                                                  
Base64編碼 https://www.convertstring.com/zh_TW/EncodeDecode/Base64Encode
HmacSHA256算法加密计算器  https://www.jisuan.mobi/pHmzuBBz11bb6XSQ.html
Hotkey為325f434b754ab4b5

A＝eyJ2Ijoidkg1WGJiTFBwSlBBRVQ2d0ptVHhWQT09IiwidCI6Ii9xNzR1TzRCTXhFZDlEY0d3b1x1MDAyQmVPT1VHXHUwMDJCQXJwbUxLNUo4L2NTU1dHdlNJPSIsIm0iOiI4MWY2YzVjZGUxMTJjMWQ0ZjM0YWNhMTYzNTFjMThkOGM5OTg2ZmY5MWJmNTM3MDkyOTlmZWY4MDM3OGZhZjgwIn0=
B＝eyJ2Ijoidkg1WGJiTFBwSlBBRVQ2d0ptVHhWQT09IiwidCI6Ii9xNzR1TzRCTXhFZDlEY0d3b1x1MDAyQmVPT1VHXHUwMDJCQXJwbUxLNUo4L2NTU1dHdlNJPSIsIm0iOiI4MWY2YzVjZGUxMTJjMWQ0ZjM0YWNhMTYzNTFjMThkOGM5OTg2ZmY5MWJmNTM3MDkyOTlmZWY4MDM3OGZhZjgwIn0=.MTYwODUxNDA4MQ==
c=eyJ2Ijoidkg1WGJiTFBwSlBBRVQ2d0ptVHhWQT09IiwidCI6Ii9xNzR1TzRCTXhFZDlEY0d3b1x1MDAyQmVPT1VHXHUwMDJCQXJwbUxLNUo4L2NTU1dHdlNJPSIsIm0iOiI4MWY2YzVjZGUxMTJjMWQ0ZjM0YWNhMTYzNTFjMThkOGM5OTg2ZmY5MWJmNTM3MDkyOTlmZWY4MDM3OGZhZjgwIn0=.MTYwODUxNDA4MQ==.8a657936251583aa1e97b96829d3d30441c168159a021a618bf040752b534993


登入
1.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirDeviceMaintain
2.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirLogin     

登入-有帳號沒密碼
1.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirDeviceMaintain  DeviceToken值維護作業
2.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirLogin           登入
3.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirUserCheckCode   忘記密碼
4https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirUserPwd          重設密碼
5.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirDeviceMaintain  DeviceToken值維護作業
6.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirLogin           登入

註冊
1.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirDeviceMaintain  DeviceToken值維護作業
2.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirLogin           沒註冊過登入
3.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirUserCheckCode   驗證碼
5.https://ws.air-go.com.tw/WS_AirGo/WS_AirGo.svc/Ws_AirUserRegister    註冊資料填寫
6.自動登入後到首頁

6.台北市松山區民權東路四段121號（25.0636447,121.5565946）--》台北市內湖區陽光街321巷42號(25.071573,121.5756166)
goole 地圖 https://www.google.com/maps/dir/105%E5%8F%B0%E5%8C%97%E5%B8%82%E6%9D%BE%E5%B1%B1%E5%8D%80%E6%B0%91%E6%AC%8A%E6%9D%B1%E8%B7%AF%E5%9B%9B%E6%AE%B5121%E8%99%9F/%E8%A6%BA%E6%97%85%E5%92%96%E5%95%A1+Journey+Kaffe+%E9%99%BD%E5%85%89%E5%BA%97/@25.0680302,121.5625119,15z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x3442abf248c49f81:0x6c20be6e4b4574fb!2m2!1d121.5587833!2d25.0636399!1m5!1m1!1s0x3442ac7c1a84aa4f:0x59744b01505ff1d4!2m2!1d121.5778053!2d25.0715682!3e0

goole API https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyBNeFrRGtXRjJdVuPBonBeWScsQn3WpIIk&language=zh-TW&mode=car&alternatives=true&departure_time=now&origin=25.0636447,121.5565946&destination=25.071573,121.5756166

結果：       "legs": [
                 {
                     "distance": {
                       "text": "4.3 公里",
                        "value": 4265
                     },
                     "duration": {
                        "text": "12 分鐘",
                         "value": 706
                     },
                     "duration_in_traffic": {
                         "text": "14 分鐘",
                         "value": 810
                  },
                    
https://api.map8.zone/route/car/121.5565946,25.0636447;121.5756166,25.071573.json                       
圖霸:  "legs": [
                     {
                         "steps": [],
                         "distance": 4231,（4.2公里）
                         "duration": 653,（11分）
                         "summary": "民權東路四段, 民權大橋"
                     }
                 ],
                 "distance": 4231,
                 "duration": 653
                                     

https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.0636447,121.5565946&destination=25.071573,121.5756166                      
勤崴:  "duration":         "legs": [
                                        {
                                            "distance": {
                                                "text": "4.7 公里",
                                                "value": 4705
                                            },
                                            "duration": {
                                                "text": "12 分鐘",
                                                "value": 707
                                            },
                                            "startAddress": "台北市松山區敦化北路405巷123弄12號",
                                            "startLocation": {
                                                "lat": 25.063737699636377,
                                                "lng": 121.55696917969577
                                            },
                                            "endAddress": "台北市內湖區瑞湖街160號",
                                            "endLocation": {
                                                "lat": 25.071828112458533,
                                                "lng": 121.57556165571016
                                            }, 

7.新北市立新莊高級中學（25.0482308,121.4423604） --》龍山寺（25.0367847,121.4977427）
https://www.google.com/maps/dir/%E6%96%B0%E5%8C%97%E5%B8%82%E7%AB%8B%E6%96%B0%E8%8E%8A%E9%AB%98%E7%B4%9A%E4%B8%AD%E5%AD%B8/%E9%BE%8D%E5%B1%B1%E5%AF%BA/@25.0244814,121.4882952,13.69z/data=!4m14!4m13!1m5!1m1!1s0x3442a7d665a34091:0x84997ebb95c03054!2m2!1d121.44454!2d25.0482262!1m5!1m1!1s0x3442a9a8d7e7de09:0xf8e8335e58c41c8a!2m2!1d121.4999007!2d25.0371623!3e0

goole API https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyBNeFrRGtXRjJdVuPBonBeWScsQn3WpIIk&language=zh-TW&mode=car&alternatives=true&departure_time=now&origin=25.0482308,121.4423604&destination=25.0367847,121.4977427

結果：          "legs": [
                             {
                                 "distance": {
                                     "text": "8.6 公里",
                                     "value": 8556
                                 },
                                 "duration": {
                                     "text": "21 分鐘",
                                     "value": 1283
                                 },
                                 "duration_in_traffic": {
                                     "text": "23 分鐘",
                                     "value": 1399
                                 },
                    
https://api.map8.zone/route/car/121.4423604,25.0482308;121.4977427,25.0367847.json                       
圖霸:     "legs": [
                     {
                         "steps": [],
                         "distance": 7644,(7.65公里)
                         "duration": 1098,（18分）
                         "summary": "幸福路, 桂林路出口"
                     }
                 ],
                 "distance": 7644,
                 "duration": 1098
                                     

https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.0482308,121.4423604&destination=25.0367847,121.4977427                      
勤崴:      "legs": [
                     {
                         "distance": {
                             "text": "10.1 公里",
                             "value": 10112
                         },
                         "duration": {
                             "text": "17 分鐘",
                             "value": 1007
                         },
                         "startAddress": "新北市新莊區中環路三段2之1號",
                         "startLocation": {
                             "lat": 25.048224745802976,
                             "lng": 121.44238320615688
                         },
                         "endAddress": "台北市萬華區廣州街245之1號",
                         "endLocation": {
                             "lat": 25.03674639800467,
                             "lng": 121.49773674537002
                         },
                                             
 8.台北市大安區臥龍街153號（25.0184128,121.5488739） --》台北市大安區四維路170巷25號（25.0283588,121.5447225）
 https://www.google.com/maps/dir/%E6%96%B0%E5%8C%97%E5%B8%82%E7%AB%8B%E6%96%B0%E8%8E%8A%E9%AB%98%E7%B4%9A%E4%B8%AD%E5%AD%B8/%E9%BE%8D%E5%B1%B1%E5%AF%BA/@25.0244814,121.4882952,13.69z/data=!4m14!4m13!1m5!1m1!1s0x3442a7d665a34091:0x84997ebb95c03054!2m2!1d121.44454!2d25.0482262!1m5!1m1!1s0x3442a9a8d7e7de09:0xf8e8335e58c41c8a!2m2!1d121.4999007!2d25.0371623!3e0
 
 goole API https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyBNeFrRGtXRjJdVuPBonBeWScsQn3WpIIk&language=zh-TW&mode=car&alternatives=true&departure_time=now&origin=25.0184128,121.5488739&destination=25.0283588,121.5447225
 
 結果：            "legs": [
                              {
                                  "distance": {
                                      "text": "1.5 公里",
                                      "value": 1549
                                  },
                                  "duration": {
                                      "text": "5 分鐘",
                                      "value": 295
                                  },
                                  "duration_in_traffic": {
                                      "text": "5 分鐘",
                                      "value": 283
                                  },
                     
 https://api.map8.zone/route/car/121.5488739,25.0184128;121.5447225,25.0283588.json                       
 圖霸:           "legs": [
                         {
                             "steps": [],
                             "distance": 1536,
                             "duration": 207,
                             "summary": "辛亥路三段, 復興南路二段"
                         }
                     ],
                     "distance": 1536,(1.5公里)
                     "duration": 207（3.5分）
                                      
 
 https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.0184128,121.5488739&destination=25.0283588,121.5447225                     
 勤崴:  "duration":      "legs": [
                                      {
                                          "distance": {
                                              "text": "1.7 公里",
                                              "value": 1669
                                          },
                                          "duration": {
                                              "text": "5 分鐘",
                                              "value": 278
                                          },
                                          "startAddress": "台北市大安區辛亥路三段115巷50號",
                                          "startLocation": {
                                              "lat": 25.017997008565153,
                                              "lng": 121.54847952168973
                                          },
                                          "endAddress": "台北市大安區復興南路二段151巷27之1號",
                                          "endLocation": {
                                              "lat": 25.028357019543026,
                                              "lng": 121.5447205625858
                                          },                                           

9.台北市中山區民權東路二段109號（25.0628706,121.5316846） --》台北市松山區饒河街（25.0504833,121.5729239）
 https://www.google.com/maps/dir/%E8%A1%8C%E5%A4%A9%E5%AE%AE/%E9%A5%92%E6%B2%B3%E8%A1%97%E8%A7%80%E5%85%89%E5%A4%9C%E5%B8%82/@25.0379291,121.5594905,13.06z/data=!4m14!4m13!1m5!1m1!1s0x3442a959a9ce781b:0xb0c2ef0be716c094!2m2!1d121.5339017!2d25.0630699!1m5!1m1!1s0x3442ab9c0db4a583:0x3da21183815df6f6!2m2!1d121.5775254!2d25.0509541!3e0
 
 goole API https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyBNeFrRGtXRjJdVuPBonBeWScsQn3WpIIk&language=zh-TW&mode=car&alternatives=true&departure_time=now&origin=25.0628706,121.5316846&destination=25.0504833,121.5729239
 
 結果：           "legs": [
                              {
                                  "distance": {
                                      "text": "7.2 公里",
                                      "value": 7180
                                  },
                                  "duration": {
                                      "text": "26 分鐘",
                                      "value": 1545
                                  },
                                  "duration_in_traffic": {
                                      "text": "25 分鐘",
                                      "value": 1490
                                  },
                     
 https://api.map8.zone/route/car/121.5316846,25.0628706;121.5729239,25.0504833.json                       
 圖霸:                       "legs": [
                               {
                                   "steps": [],
                                   "distance": 6139,
                                   "duration": 929,
                                   "summary": "南京東路五段, 饒河街"
                               }
                           ],
                           "distance": 6139,(6.1公里)
                           "duration": 9299
                                      
 
 https://openapi.autoking.com.tw/api/CarNavi/Directions?origin=25.0628706,121.5316846&destination=25.0504833,121.5729239                     
 勤崴:  "legs": [
                      {
                          "distance": {
                              "text": "6.3 公里",
                              "value": 6258
                          },
                          "duration": {
                              "text": "15 分鐘",
                              "value": 897
                          },
                          "startAddress": "台北市中山區民權東路二段71巷1號",
                          "startLocation": {
                              "lat": 25.062864260351038,
                              "lng": 121.53172029328225
                          },
                          "endAddress": "台北市松山區饒河街40號",
                          "endLocation": {
                              "lat": 25.050224938199943,
                              "lng": 121.57300291703855
                          },    

10.台北市中正區同安街107號（ 25.0215627,121.5183454 ） --》象山站 110台北市信義區（25.0328194,121.5678934）
 https://www.google.com/maps/dir/%E7%B4%80%E5%B7%9E%E5%BA%B5%E6%96%87%E5%AD%B8%E6%A3%AE%E6%9E%97/%E8%B1%A1%E5%B1%B1%E7%AB%99/@25.0317589,121.570349,15.7z/data=!4m14!4m13!1m5!1m1!1s0x3442a9914fa74afd:0xd9c379af4e53232e!2m2!1d121.5205108!2d25.0215166!1m5!1m1!1s0x3442abb1ccfde3fd:0xcab3efeb34d82998!2m2!1d121.5700821!2d25.0328146!3e0
 
 goole API https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyBNeFrRGtXRjJdVuPBonBeWScsQn3WpIIk&language=zh-TW&mode=car&alternatives=true&departure_time=now&origin= 25.0215627,121.5183454 &destination=25.0328194,121.5678934
 
 結果：           "legs": [
                              {
                                  "distance": {
                                      "text": "6.4 公里",
                                      "value": 6398
                                  },
                                  "duration": {
                                      "text": "23 分鐘",
                                      "value": 1379
                                  },
                                  "duration_in_traffic": {
                                      "text": "25 分鐘",
                                      "value": 1476
                                  },
                                  "end_address": "110台灣台北市信義區信義路五段17號",
                                  "end_location": {
                                      "lat": 25.0328074,
                                      "lng": 121.5678932
                                  },
                                  "start_address": "100台灣台北市中正區廈門街147巷1-26號",
                                  "start_location": {
                                      "lat": 25.0213042,
                                      "lng": 121.5182462
                                  },
                      
 https://api.map8.zone/route/car/121.5183454,25.0215627;121.5678934,25.0328194.json                       
 圖霸:                         "legs": [
                                   {
                                       "steps": [],
                                       "distance": 6208,6.2公里）
                                       "duration": 714,（12分）
                                       "summary": "和平東路一段, 基隆路二段"
                                   }
                               ],
                               "distance": 6208,（
                               "duration": 714
                           }
                                      
 
 https://openapi.autoking.com.tw/api/CarNavi/Directions?origin= 25.0215627,121.5183454 &destination=25.0328194,121.5678934                    
 勤崴:      {
                          "distance": {
                              "text": "6.0 公里",
                              "value": 6042
                          },
                          "duration": {
                              "text": "13 分鐘",
                              "value": 750
                          },
                          "startAddress": "台北市中正區廈門街147巷1之17號",
                          "startLocation": {
                              "lat": 25.02170733896643,
                              "lng": 121.5183449310462
                          },
                          "endAddress": "台北市信義區信義路五段17號",
                          "endLocation": {
                              "lat": 25.032775312543826,
                              "lng": 121.56788797139747
                          },
                              "lng": 121.54409253180143
                          },                                               
                                                                                     


網約車的軟體開發專案，主要包含App及後台API為主團隊，將後台建置於"GCP 雲"之上（使用Java Spring Boot開發)，APP(IOS-Swift及Android-java,目前新的APP開發己改跨平台工具Flutter)，後台管理系統採用Vue.js框架單頁應用(SPA)，前後端分離開發：

前端工程團隊
* 模組化App Component，跨專案共同開發/使用
* 分層結構開發App Application
* 透過 (Jenkins+ fastlane)自動編譯部署(App)前端程式碼
* 統一原始碼規範
* App手機應用(IOS&Android)

後端工程團隊
* 具備開發 大規模/高可用性 的 RESTFul 分散式應用服務的能力
* 使用Docker 資源,實現高可用性+高擴充性
* 設計完善資料庫Schema，實現每天處理上萬筆資料
* 具備完善 CI/CD 軟體開發流程
* 撰寫 Unit Test 確保程式品質
* 透過 Jenkins ＋Docker實現 自動部署應用服務
* 自動收集 Log

無論是前台還是後台系統，都共享相同的微服務集群，包括：
*搜索微服務：實現搜索功能（使用Elasticsearch全文搜尋功能）
*用戶中心：用戶的登錄註冊等功能（Spring Security）
*Eureka註冊中心
*Zuul網關服務（API網關為微服務架構中的服務提供了統一的訪問入口，客戶端通*過網關訪問相關服務)
*Spring Cloud Config配置中心（微服務應用提供集中化的外部配置支持，分為服務端和客戶端)

後端技術：
*基礎的SpringMVC、Spring 5.0和MyBatis3
*Spring Boot 2.0.1版本
*Spring Cloud 最新版 Finchley.RC1
*Redis-4.0
*RabbitMQ-3.4
*Elasticsearch-5.6.8
*nginx-1.10.2
*FastDFS - 5.0.8

項目參考：
https://play.google.com/store/apps/details?id=tw.com.hantek.car4u.passenger.carplus

軟體設計工程師 管理5~8人 台北市內湖區
2017/7~2019/2
1年8個月
開發一個類似FB的社交軟體，包含了Web，App及後台API為主團隊，將後台建置於Google GCP之上，資料庫則使用了MySQL,前端網頁使用了Bootstrap開發，App部份IOS使用了swift開發，Android則使用Java進行開發。API後台則採用了PHP語言開發。
工具使用上一樣採用了，版本控管使用了git，Jenkins進行自動打包，TestFlight及Daiwei進行APP打包測試開。
發流程控管：使用了Scrum方式進行，Redmine進行BUG控管，wki進行文件管理。

項目參考：
該產品己停止供應


主要工作為音樂管理平台，建置包含了後台（使用Java開發，架於AWS）及前端App（IOS及Android）應用部份，Server主提供了歌相關資訊，API使用RESTful定義，開發語言為Java，APP為IOS及Android，提供使用者平台。主要就以server及APP串起的團隊。以穩定快速開發為目標。
開發工具及使用：
1.版本控管使用了git。2.使用Jenkins進行自動打包.3.使用了TestFlight及Daiwei進行打包測試。3.Unit test進行程式化自動化測試。
開發流程控管：
1.使用了Scrum方式進行。2. Redmine進行BUG控管。

項目參考：
https://play.google.com/store/apps/details?id=escapemusic.android.a635



希望從事建立新開發團隊相關工作。（含Spring Boot Server及Spring Clound後端，Flutter APP團隊建立等相關軟體開發團隊之建置）目前App開發部份己採用跨平台Flutter，不在使用原生工具。
我自己本身主要専長為Spring Boot 後瑞及Flutter，IOS及Android這些App項目為主，有相關開發及團隊建置經驗並能獨立開發，流程及相關規化能力。


網約車相關軟體開發專案，主要開發後端(Java Spring Boot)及相關APP，使用相關原生開發工具(Xcode)及跨平台開發工具Flutter。

 相關項目包含：網約車及定點租車及機場接送及一站式多元移動服務平台APP。
 使用相關技術含:Bluetooth，MQTT，Firebase Analytics ，FCM，Google Map Api ，Restful api。
項目參考：
https://play.google.com/store/apps/details?id=com.carplus.goSmart
https://play.google.com/store/apps/details?id=tw.com.hantek.car4u.passenger.carplus
https://play.google.com/store/apps/details?id=com.car_plus.carshare
https://play.google.com/store/apps/details?id=com.carplus.airportgo
