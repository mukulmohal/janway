using JWA.Api.Response;
using JWA.Core.DTOs;
using Microsoft.AspNetCore.Mvc;
using System;

namespace JWA.Api.Controllers
{
    //[Authorize(Roles = "SystemAdministrator"]
    //[Authorize]
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class deviceController : ControllerBase
    {
        /*private readonly ISupervisorService _supervisorService;
        private readonly IMapper _mapper;
        private readonly IUriService _uriService;
        private readonly IPasswordService _passwordService;*/
        public deviceController()//ISupervisorService supervisorService, IMapper mapper, IUriService uriService, IPasswordService passwordService)
        {
            /*_supervisorService = supervisorService;
            _mapper = mapper;
            _uriService = uriService;
            _passwordService = passwordService;*/
        }

        ///// <summary>
        ///// Retrieve all supervisors depending on supervisor role and organization.
        ///// </summary>
        ///// <param name="filters">Filters to apply</param>
        ///// <returns></returns>
        //[HttpGet(Name = "[controller][action]")]
        //[ProducesResponseType((int)HttpStatusCode.OK, Type = typeof(ApiResponse<IEnumerable<SupervisorDto>>))]
        //[ProducesResponseType((int)HttpStatusCode.BadRequest)]
        //public IActionResult GetAll([FromQuery]SupervisorQueryFilter filters)
        //{
        //    var supervisors = _supervisorService.GetSupervisors(filters);
        //    var supervisorsDto = _mapper.Map<IEnumerable<SupervisorDto>>(supervisors);

        //    var metadata = new Metadata
        //    {
        //        TotalCount = supervisors.TotalCount,
        //        PageSize = supervisors.PageSize,
        //        CurrentPage = supervisors.CurrentPage,
        //        TotalPages = supervisors.TotalPages,
        //        HasNextPage = supervisors.HasNextPage,
        //        HasPreviousPage = supervisors.HasPreviousPage,
        //        NextPageUrl = _uriService.GetPaginationUri(Url.RouteUrl(nameof(GetAll))).ToString(),
        //        PreviousPageUrl = _uriService.GetPaginationUri(Url.RouteUrl(nameof(GetAll))).ToString()
        //    };

        //    var response = new ApiResponse<IEnumerable<SupervisorDto>>(supervisorsDto)
        //    {
        //        Meta = metadata
        //    };

        //    return Ok(response);
        //}

        ///// <summary>
        ///// Retrieve supervisor information.
        ///// </summary>
        ///// <param name="id">Supervisor id</param>
        ///// <returns></returns>
        //[HttpGet("{id}")]
        //public async Task<IActionResult> Get(int id)
        //{
        //    var supervisor = await _supervisorService.GetSupervisor(id);
        //    var supervisorDto = _mapper.Map<SupervisorDto>(supervisor);
        //    var response = new ApiResponse<SupervisorDto>(supervisorDto);
        //    return Ok(response);
        //}

        [HttpPost]
        [Route("register")]
        public IActionResult register(RegisterDto registerDto)
        {
            if (String.IsNullOrEmpty(registerDto.device_id))
                return BadRequest();

            var response = new ApiResponse<bool>(true);
            return Ok(response);
        }

        [HttpGet]
        [Route("request_access")]
        public IActionResult request_access(string encodedDeviceId) //encoded_base64_device_id
        {
            string jwt_token = "testJWTtoken";
            var response = new ApiResponse<string>(jwt_token);
            return Ok(response);
        }

        [HttpPost]
        [Route("system_status")]
        public IActionResult system_status(SystemStatusDto systemStatusDto)
        {
            var response = new ApiResponse<bool>(true);
            return Ok(response);
        }

        [HttpPost]
        [Route("flush")]
        public IActionResult flush(FlushDto flushDto)
        {
            var response = new ApiResponse<bool>(true);
            return Ok(response);
        }

        [HttpGet]
        [Route("credentials_rejected")]
        public IActionResult credentials_rejected()
        {
            var response = new ApiResponse<bool>(true);
            return Ok(response);
        }

        [HttpGet]
        [Route("credentials_digested")]
        public IActionResult credentials_digested()
        {
            var response = new ApiResponse<bool>(true);
            return Ok(response);
        }
    }
}
