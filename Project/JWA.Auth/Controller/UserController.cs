using JWA.Auth.Models;
using JWA.Core.Entities;
using JWA.Core.Interfaces;
using JWA.Infrastructure.Interfaces;
using JWA.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace JWA.Auth.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IPasswordService _passwordService;
        private readonly IInviteService _inviteservice;

        public UserController(IUserService userService, IPasswordService passwordService,
                                IInviteService inviteservice)
        {
            _userService = userService;
            _passwordService = passwordService;
            _inviteservice = inviteservice;
        }

        [HttpPost]
        [Route("ConfirmEmail")]
        public async Task<IActionResult> ConfirmEmail(ConfirmEmailViewModel confirmEmailViewModel)
        {
            try
            {
                if (confirmEmailViewModel.Password != confirmEmailViewModel.ConfirmPassword)
                {
                    return BadRequest("Email is not confirmed");
                }
                else
                {
                    try
                    {
                        User user = new User();
                        user.Id = Guid.NewGuid();
                        user.Email = confirmEmailViewModel.Email;
                        user.UserName = confirmEmailViewModel.UserName;
                        user.NormalizedUserName = confirmEmailViewModel.UserName;
                        user.NormalizedEmail = confirmEmailViewModel.Email;
                        user.EmailConfirmed = true;
                        user.PasswordHash = _passwordService.Hash(confirmEmailViewModel.Password); ;
                        user.PhoneNumberConfirmed = false;
                        user.TwoFactorEnabled = false;
                        user.LockoutEnabled = false;
                        user.AccessFailedCount = 0;
                        user.CreationDate = DateTime.Now;

                        var inviteID = await _userService.InsertUser(user);
                        var invite = _inviteservice.GetInviteByEmailId(confirmEmailViewModel.Email);
                        var invitedelete = _inviteservice.DeleteInvite(invite.Id);
                        return Ok(user);
                    }
                    catch (Exception ex)
                    {
                        return BadRequest(ex.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }            
        }

        [HttpPost]
        [Route("InviteUser")]
        public async Task InviteUser(InviteViewModel inviteViewModel)
        {
            Invite invite = new Invite();
            invite.Email = inviteViewModel.Email;
            invite.FacilityId = inviteViewModel.FacilityId;
            invite.OrganizationId = inviteViewModel.OrganizationId;
            invite.RoleId = inviteViewModel.RoleId;
            invite.CreationDate = DateTime.Now;

            var InvitedUser = await _inviteservice.InsertInvite(invite);
        }
    }
}
