using BTL_LTWNC.Data;
using BTL_LTWNC.Models.EF;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace BTL_LTWNC.Controllers
{
    public class ProductController : Controller
    {
        private readonly AppDbContext _dbContext;

        public ProductController(AppDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpGet]
        [Route("shop")]
        public async Task<IActionResult> getAllProduct()
        {
            var data = await _dbContext.tblProduct.ToListAsync();
            var categories = await _dbContext.tblProductCategory.ToListAsync();
            ViewData["Categories"] = categories;

            return View(data);
        }

        [HttpGet]
        [Route("productDetails")]
        public async Task<IActionResult> productDetails(int id)
        {
            if (id.ToString() == null)
            {
                return NotFound();
            }

            var product = await _dbContext.tblProduct.Where(x => x.iProductID == id).SingleOrDefaultAsync();

            SqlParameter cateID = new SqlParameter("@categoryID", product.iProductCategoryID);

            var relatedProduct = await _dbContext.tblProduct.FromSqlRaw("spGetRelatedProduct @categoryID", cateID).ToListAsync();

            ViewBag.relatedProduct = relatedProduct;

            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        [HttpPost]
        public IActionResult Search(string keyword)
        {
            var products = _dbContext.tblProduct.FromSqlRaw("select * from tblProduct where sProductName like N'%" + keyword + "%' ");
            // return Json(products); 
            return View("getAllProduct", products);
        }

        [Route("/product/sort/{sortType?}")]
        public IActionResult Sort(string sortType = "")
        {
            IEnumerable<Product> products = null;
            switch (sortType)
            {
                case "smaller200000":
                    products = _dbContext.tblProduct.FromSqlRaw("select * from tblProduct where fPrice < 2000000");
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
            return View("getAllProduct", products);
        }

    }
}
