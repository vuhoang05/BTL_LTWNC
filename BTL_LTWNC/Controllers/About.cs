using Microsoft.AspNetCore.Mvc;

namespace BTL_LTWNC.Controllers
{
    public class About : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
