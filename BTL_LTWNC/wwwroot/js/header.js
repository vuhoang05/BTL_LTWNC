window.onscroll = function () { myFunction() };

var header = document.getElementById("myHeader");

function myFunction() {
    if (document.body.scrollTop > 80 ||
        document.documentElement.scrollTop > 80) {
        header.classList.add("sticky");
    } else {
        header.classList.remove("sticky");
    }
}
//responsive
const mobileIcon = document.querySelector('.mobile__icon');
const mobileMenu = document.querySelector('.mobile__menu');

mobileIcon.addEventListener('click', () => {
    mobileMenu.classList.toggle('active');
});

// Tùy chọn: Đóng menu khi click ngoài
document.addEventListener('click', (event) => {
    if (!event.target.closest('.mobile__menu') && !event.target.closest('.mobile__icon')) {
        mobileMenu.classList.remove('active');
    }
});
