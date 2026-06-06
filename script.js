$(document).ready(function() {
    initializeNavigation();
    setupTextLines();
    initializeHighlighting();
    setupAnnotationPanel();
    setupZoneHighlighting();   // ora raggiunta correttamente
    setupFormWork();
    setupEntityLinks();
    setupColumnBreaks();


    setTimeout(resizeZones, 300);
    $(window).on('load', function() {
        resizeZones();
    });
});


//Converte il contenuto TEI in righe di testo cliccabili
function setupTextLines() {
    $('.text-paragraph, p, .article-body > *, .text-column > *').each(function() {
        const container = $(this);
        
        if (container.hasClass('processed-lines') || container.hasClass('line-break') || container.hasClass('text-line')) {
            return;
        }
        
        container.addClass('processed-lines');
        processContainerLines(container);
    });
    
    $('.column-break, .page-break').each(function() {
        if (!$(this).hasClass('text-line')) {
            $(this).addClass('text-line');
        }
    });
    
    $('.fw').each(function() {
        if (!$(this).hasClass('text-line') && !$(this).hasClass('processed-lines')) {
            $(this).addClass('text-line processed-lines');
        }
    });
}

// Elabora un singolo container dividendolo in righe basandosi sui line breaks TEI
function processContainerLines(container) {
    const lineBreaks = container.find('.line-break');

    if (lineBreaks.length === 0) {
        container.addClass('text-line');
        if (!container.attr('id')) container.attr('id', 'line-' + generateUniqueId());
        return;
    }

    const containerId = container.attr('id') || 'container-' + generateUniqueId();
    const tempContainer = $('<div>').html(container.html());

    let lineNumber = 1;
    tempContainer.find('.line-break').each(function() {
        const lb = $(this);
        const lbId = lb.attr('id') || `${containerId}-lb-${lineNumber}`;
        let markerHtml = `<span class="line-marker" data-line-id="${lbId}"></span>`;
        if (lb.attr('data-break') === 'no') markerHtml = '-' + markerHtml;
        lb.before(markerHtml);
        lineNumber++;
    });

    const parts = tempContainer.html().split(/<span class="line-marker"[^>]*><\/span>/);
    container.empty();

    parts.forEach((part, index) => {
        if (part.trim()) {
            const lbMatch = part.match(/<span[^>]*class="line-break"[^>]*\s+id="([^"]+)"/);
            const lineId = lbMatch ? lbMatch[1] : `${containerId}-line-${index + 1}`;
            const cleanContent = part.replace(/<span[^>]*class="line-break"[^>]*><\/span>/g, '');
            const line = $('<div class="text-line"></div>').attr('id', lineId).html(cleanContent);
            container.append(line);
        }
    });

    container.removeClass('text-paragraph list-item');
}

// Genera ID univoci per elementi che non ne hanno uno
let idCounter = 0;
function generateUniqueId() {
    return 'gen-' + Date.now() + '-' + (idCounter++);
}

// Gestisce il click tra elementi di testo e zone SVG del facsimile
function setupZoneHighlighting() {
    $('svg rect').css('pointer-events', 'auto');

    $(document).on('click', 'svg rect', function(e) {
        e.stopPropagation();
        const rectClass = $(this).attr('class');
        if (!rectClass) return;

        const targetElement = $('[id="' + rectClass + '"]');
        if (targetElement.length) {
            $('svg rect.selected').removeClass('selected');
            $('.highlight-text').removeClass('highlight-text');
            $(this).addClass('selected');
            targetElement.addClass('highlight-text');
            scrollToElement(targetElement);
        }
    });

    $(document).on('click', '.text-line, .fw, .article-title, .column-break, .page-break', function(e) {
        if ($(e.target).closest('.entity-link').length) return;

        const elementId = $(this).attr('id');
        if (!elementId) return;

        const rect = findRectById(elementId);
        if (rect.length) {
            $('svg rect.selected').removeClass('selected');
            $('.highlight-text').removeClass('highlight-text');
            $(this).addClass('highlight-text');
            rect.addClass('selected');
            scrollToRect(rect);
        }
    });
}

// Trova rettangolo SVG tramite ID 
function findRectById(id) {
    let rect = $(`rect[class="${id}"]`);
    if (!rect.length) {
        rect = $(`rect[class*="${id}"]`);
    }
    return rect;
}

// Scrolla la colonna testo per rendere visibile l'elemento selezionato
function scrollToElement(element) {
    const textCol = element.closest('.text-column');
    if (textCol.length) {
        const relTop = element.offset().top - textCol.offset().top + textCol.scrollTop() - 60;
        textCol.animate({ scrollTop: relTop }, 300);
    } else if (!isElementInViewport(element[0])) {
        $('html, body').animate({ scrollTop: element.offset().top - 100 }, 300);
    }
}

// Scrolla il container del facsimile per rendere visibile un rettangolo SVG
function scrollToRect(rect) {
    if (!isElementInViewport(rect[0])) {
        const pageContainer = rect.closest('.page-facsimile');
        if (pageContainer.length) {
            const container = pageContainer.closest('.facsimile-container');
            const containerTop = container.offset().top;
            const rectTop = rect.offset().top;
            const scrollTop = container.scrollTop() + (rectTop - containerTop) - 50;
            
            container.animate({ scrollTop: scrollTop }, 300);
        }
    }
}

// Gestisce il menu di navigazione  
function initializeNavigation() {
    $('.section-link').on('click', function(event) {
        event.preventDefault();

        var targetId = $(this).attr('href');
        var infoSubs = ['#document-info', '#people-section', '#places-section',
                        '#org-section', '#event-section', '#info-section'];

        if (infoSubs.indexOf(targetId) !== -1) {
            $('.visible-section').removeClass('visible-section').addClass('hidden-section');
            $('#info-section').removeClass('hidden-section').addClass('visible-section');

            if (targetId !== '#info-section') {
                setTimeout(function() {
                    var target = $(targetId);
                    if (target.length) {
                        $('html, body').scrollTop(target.offset().top - 70);
                    }
                }, 100);
            } else {
                $('html, body').scrollTop(0);
            }

            $('.chip').removeClass('chip-active');
            $('.chip[href="#info-section"]').addClass('chip-active');
            $('.bottom-header').addClass('hidden');

        } else {
            var sectionId = targetId + '-section';
            $('.visible-section').removeClass('visible-section').addClass('hidden-section');
            $(sectionId).removeClass('hidden-section').addClass('visible-section');
            $('html, body').scrollTop(0);

            $('.chip').removeClass('chip-active');
            $('.chip[href="' + targetId + '"]').addClass('chip-active');
            $('.bottom-header').removeClass('hidden');

            setTimeout(resizeZones, 80);
        }
    });
}

// Gestisce i bottoni da evidenziati a non evidenziati
function setupAnnotationPanel() {
    $('.tool-btn').on('click', function() {
        $(this).toggleClass('active');
        updateHighlights();
    });
}

// Mette o rimuove evidenziazioni basandosi sui bottoni attivi nel pannello
function updateHighlights() {
    $('.entity').removeClass('highlight');
    $('.quote, .quote-block').removeClass('highlighted');

    $('.tool-btn.active').each(function() {
        const type = $(this).data('type');
        if (!type) return;
        
        if (type === 'quote') {
            $('.quote, .quote-block').addClass('highlighted');
        } else if (type === 'damage') {
            $('.entity.damage, .entity.unclear').addClass('highlight');
        } else if (type === 'persName') {
            $('.entity.persName:not(.character)').addClass('highlight');
        } else if (type === 'character') {
            $('.entity.persName.character').addClass('highlight');
        } else if (type === 'orgName') {
            $('.entity.orgName:not(.tipografia):not(.casa-editrice)').addClass('highlight');
        } else if (type === 'tipografia') {
            $('.entity.orgName.tipografia').addClass('highlight');
        } else if (type === 'casa-editrice') {
            $('.entity.orgName.casa-editrice').addClass('highlight');
        } else if (type === 'tei-title') {
            $('.entity.tei-title').addClass('highlight');
        } else {
            $(`.entity.${type}`).addClass('highlight');
        }
    });

    const foreignActive = $('.foreign-btn').hasClass('active');
    $('.foreign-translation').toggleClass('visible', foreignActive);
    $('.quote-translation').toggleClass('visible', foreignActive);
}


// Verifica i collegamenti tra elementi di testo e rettangoli SVG
function initializeHighlighting() {
    setTimeout(function() {
        $('.text-line, .fw, .article-title, .column-break, .page-break').each(function() {
            const id = $(this).attr('id');
            if (id) {
                const rect = $(`rect[class="${id}"]`);
                if (rect.length) {
                    console.log(`Collegato elemento ${id} con rettangolo SVG`);
                }
            }
        });
    }, 100);
}

// Gestisce i click sui link delle entità (persone, luoghi, termini) per mostrare popup
function setupEntityLinks() {
    $(document).on('click', '.entity-link', function(e) {
        e.preventDefault();

        const targetId = $(this).attr('href');
        if (!targetId) return;

        const targetElement = $(targetId);
        if (!targetElement.length) return;

        if (targetElement.hasClass('entity-item')) {
            let type = 'person';
            if (targetElement.closest('#places-section').length)    type = 'place';
            else if (targetElement.closest('#org-section').length)  type = 'org';
            else if (targetElement.closest('#event-section').length) type = 'event';
            else if (targetElement.closest('#bibl-section').length)   type = 'bibl';

            showEntityCard(targetElement, type);
        }
    });
}

// Crea e mostra popup con informazioni dettagliate su un'entità
function showEntityCard(element, type) {
    if (!element.length) return;

    const classMap = {
        person: 'persName',
        place:  'placeName',
        org:    'orgName',
        event:  'event', 
        bibl:   'tei-title'  
    };

    const title     = element.find('h3').text();
    const className = classMap[type] || 'persName';
    let   content   = element.find('.person-details').html();

    if (!content) {
        const clone = element.clone();
        clone.find('h3').remove();
        content = clone.html();
    }

    $('.entity-overlay').remove();

    const overlay = $(`
        <div class="entity-overlay">
            <div class="entity-card">
                <div class="entity-card-header ${className}">
                    <h3>${title}</h3>
                    <button class="entity-card-close">&times;</button>
                </div>
                <div class="entity-card-body">
                    ${content}
                </div>
            </div>
        </div>
    `);

    $('body').append(overlay);

    overlay.on('click', function(e) {
        if ($(e.target).is('.entity-overlay') || $(e.target).is('.entity-card-close')) {
            overlay.remove();
        }
    });
}

// Gestisce i column break
function setupColumnBreaks() {
    $('.column-break').each(function() {
        var columnBreak = $(this);
        var div = columnBreak.closest('.text-div');
        div.removeClass('no-column').addClass('multi-column');
    });
}


// Processa elementi fw per intestazioni e piè di pagina
function setupFormWork() {
    $('.fw').each(function() {
        const fw = $(this);
        const place = fw.attr('data-place') || '';
        const placeClass = place.replace(/\s+/g, '-');
        if (placeClass) fw.addClass(placeClass);
        if (!fw.hasClass('text-line')) fw.addClass('text-line');
    });
}

// Verifica se un elemento è visibile nel viewport
function isElementInViewport(el) {
    if (!el) return false;
    const rect = el.getBoundingClientRect();
    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
}

// Allinea l'SVG overlay alle dimensioni reali dell'immagine facsimile
function resizeZones() {
    $('.page-facsimile').each(function() {
        const container = $(this);
        const img = container.find('.facsimile-image');
        const svg = container.find('svg.overlay');
        if (!img.length || !svg.length) return;

        const w = img.width();
        const h = img.height();
        if (w === 0 || h === 0) return;

        svg.css({ width: w + 'px', height: h + 'px' });
    });
}

$(window).on('resize', function() {
    resizeZones();
});
