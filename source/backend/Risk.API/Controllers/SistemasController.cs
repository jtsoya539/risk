using System.Threading.Tasks;

using Microsoft.EntityFrameworkCore;

using Microsoft.AspNetCore.Mvc;


using Risk.API.Entities;

namespace Risk.API.Controllers

{

    [Route("api/[controller]")]
    [ApiController]
    public class SistemasController : Controller

    {



        private readonly RiskDbContext _context;



        public SistemasController(RiskDbContext context)

        {

            _context = context;

        }



        // Retrieve data from Blogs
        [HttpGet]
        public async Task<IActionResult> Index()

        {

            return View(await _context.TSistemas.ToListAsync());

        }

    }

}