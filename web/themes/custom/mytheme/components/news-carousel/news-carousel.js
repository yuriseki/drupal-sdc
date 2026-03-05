/**
 * @file
 * News Carousel behaviour.
 *
 * Handles previous/next navigation, dot indicators, and keyboard support.
 * Desktop shows 3 cards; tablet shows 2; mobile shows 1.
 */
(function (Drupal) {
  'use strict';

  Drupal.behaviors.newsCarousel = {
    attach(context) {
      const carousels = context.querySelectorAll
        ? context.querySelectorAll('.news-carousel')
        : [];

      carousels.forEach((carousel) => {
        if (carousel.dataset.carouselInit) return;
        carousel.dataset.carouselInit = '1';

        const track = carousel.querySelector('.news-carousel__track');
        const items = Array.from(carousel.querySelectorAll('.news-carousel__item'));
        const btnPrev = carousel.querySelector('.news-carousel__btn--prev');
        const btnNext = carousel.querySelector('.news-carousel__btn--next');
        const indicators = Array.from(carousel.querySelectorAll('.news-carousel__indicator'));

        if (!track || !items.length) return;

        let currentIndex = 0;

        function getVisibleCount() {
          const w = window.innerWidth;
          if (w <= 600) return 1;
          if (w <= 1024) return 2;
          return 3;
        }

        function getCardWidth() {
          if (!items[0]) return 0;
          return items[0].offsetWidth;
        }

        function getGap() {
          const style = window.getComputedStyle(track);
          return parseInt(style.gap || style.columnGap || '0', 10);
        }

        function maxIndex() {
          return Math.max(0, items.length - getVisibleCount());
        }

        function goTo(index) {
          const clampedIndex = Math.max(0, Math.min(index, maxIndex()));
          currentIndex = clampedIndex;

          const cardWidth = getCardWidth();
          const gap = getGap();
          const offset = clampedIndex * (cardWidth + gap);
          track.style.transform = `translateX(-${offset}px)`;

          // Update aria-hidden on items.
          items.forEach((item, i) => {
            const visible = i >= clampedIndex && i < clampedIndex + getVisibleCount();
            item.setAttribute('aria-hidden', visible ? 'false' : 'true');
          });

          // Update indicators.
          indicators.forEach((dot, i) => {
            const active = i === clampedIndex;
            dot.classList.toggle('news-carousel__indicator--active', active);
            dot.setAttribute('aria-selected', active ? 'true' : 'false');
          });

          // Update button states.
          btnPrev.disabled = clampedIndex === 0;
          btnNext.disabled = clampedIndex >= maxIndex();
        }

        // Button listeners.
        btnPrev.addEventListener('click', () => goTo(currentIndex - 1));
        btnNext.addEventListener('click', () => goTo(currentIndex + 1));

        // Indicator listeners.
        indicators.forEach((dot, i) => {
          dot.addEventListener('click', () => goTo(i));
        });

        // Keyboard navigation on the track wrapper.
        carousel.addEventListener('keydown', (e) => {
          if (e.key === 'ArrowLeft') {
            e.preventDefault();
            goTo(currentIndex - 1);
          } else if (e.key === 'ArrowRight') {
            e.preventDefault();
            goTo(currentIndex + 1);
          }
        });

        // Recalculate on resize.
        let resizeTimer;
        window.addEventListener('resize', () => {
          clearTimeout(resizeTimer);
          resizeTimer = setTimeout(() => goTo(currentIndex), 150);
        });

        // Initial state.
        goTo(0);
      });
    },
  };
}(Drupal));
