using BTL_LTWNC.Data;
using BTL_LTWNC.Models.EF;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BTL_LTWNC.Controllers
{
    public class Product2Controller : Controller
    {
        private readonly AppDbContext _dbContext;
        public Product2Controller(AppDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        [HttpGet]
        [Route("Chức Năng Sản Phẩm")]
        public async Task<IActionResult> index()
        {
            var data = await _dbContext.tblProduct.ToListAsync();

            return View(data);
        }
        [Route("/product2/sort/{sortType?}")]
        public IActionResult Sort(string sortType = "")
        {
            IEnumerable<Product> products = null;
            switch (sortType)
            {
                case "smaller200000":
                    products = _dbContext.tblProduct.FromSqlRaw("select iProductID, sProductName, iProductCategoryId, fPrice, sImageUrl, Descreption from tblProduct,tblProductCategory where tblProduct.iProductCategoryId= tblProductCategory.iCategoryID and fPrice < 2000000 and sCategoryName = N'Mì'");
                    break;
                case "bigger10000000":
                    products = _dbContext.tblProduct.FromSqlRaw("select * from tblProduct where fPrice between 100000 and 200000 order by (fPrice) asc ");
                    break;
                case "ASC":
                    products = _dbContext.tblProduct.FromSqlRaw("select * from tblProduct order by (fPrice) asc ");
                    break;
                case "DESC":
                    products = _dbContext.tblProduct.FromSqlRaw("select * from tblProduct order by (fPrice) desc ");
                    break;
            }
            //var products = _dbContext.tblProduct.FromSqlRaw("select * from tblProduct where fPrice between 100000 and 200000 order by (fPrice) asc ");
            return View("index", products);
        }

        public IActionResult Index()
        {
            return View();
        }
    }
}
