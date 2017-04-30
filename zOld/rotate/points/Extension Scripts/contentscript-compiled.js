var q = function(a, b) {
        return a.charCodeAt(b) & 255 | (a.charCodeAt(b + 1) & 255) << 8 | (a.charCodeAt(b + 2) & 255) << 16 | (a.charCodeAt(b + 3) & 255) << 24
    },
    t = Math.imul || function(a, b) {
        var n = a & 65535,
            w = b & 65535;
        return n * w + ((a >>> 16 & 65535) * w + n * (b >>> 16 & 65535) << 16 >>> 0) | 0
    },
    x = function(a, b) {
        return a << b | a >>> 32 - b
    },
    y = function(a) {
        a = t(a ^ a >>> 16, 2246822507);
        a ^= a >>> 13;
        a = t(a, 3266489909);
        return a ^= a >>> 16
    },
    A = function(a) {
        a = (a >>> 0).toString(16);
        return "00000000".substr(a.length) + a
    };
var B = {
        creators_name: "author",
        creator: "author",
        contributor: "author",
        issued: "publication_year",
        publication_date: "publication_year",
        date: "year"
    },
    C = {
        "abstract": 1,
        description: 1,
        keyword: 1,
        keywords: 1,
        reference: 1
    },
    D = /^.*_(url|email|institution)$/,
    E = /  +/g,
    F = function(a) {
        return a.replace(/[-+":]/g, " ").substr(0, 500)
    },
    G = function(a, b, n) {
        a = B[a] || a;
        !b || C[a] || D.test(a) || n.push(encodeURIComponent(a) + "=" + encodeURIComponent(b))
    },
    H = function(a, b) {
        for (; a;) {
            var n = b[a];
            if (n)
                return n;
            n = a.indexOf(".");
            if (0 > n)
                break;
            a = a.substr(n +
            1)
        }
    },
    I = "innerText" in document.documentElement ? function(a) {
        return a.innerText
    } : function(a) {
        if (1 == a.nodeType) {
            var b = document.defaultView.getComputedStyle(a);
            return "none" == b.display || "hidden" == b.visibility || 0 >= parseFloat(b.fontSize) || 0 >= parseFloat(b.opacity) ? "" : Array.prototype.map.call(a.childNodes, I).join(" ").replace(E, " ")
        }
        return a.textContent
    };
var J = function(a) {
        function b(a) {
            for (var d = 1463435680, f = 1463435680, c = 1463435680, g = 1463435680, h = 0, k = 0, e = 0, b = 0, n = a.length, m = n >> 4 << 4, p = 0; p < m; p += 16)
                h = q(a, p), k = q(a, p + 4), e = q(a, p + 8), b = q(a, p + 12), h = t(h, 597399067), h = x(h, 15), h = t(h, 2869860233), d ^= h, d = x(d, 19), d += f, d = 5 * d + 1444728091 >>> 0, k = t(k, 2869860233), k = x(k, 16), k = t(k, 951274213), f ^= k, f = x(f, 17), f += c, f = 5 * f + 197830471 >>> 0, e = t(e, 951274213), e = x(e, 17), e = t(e, 2716044179), c ^= e, c = x(c, 15), c += g, c = 5 * c + 2530024501 >>> 0, b = t(b, 2716044179), b = x(b, 18), b = t(b, 597399067), g ^= b, g = x(g, 13),
                g += d, g = 5 * g + 850148119 >>> 0;
            b = e = k = h = 0;
            switch (n & 15) {
            case 15:
                b ^= (a.charCodeAt(m + 14) & 255) << 16;
            case 14:
                b ^= (a.charCodeAt(m + 13) & 255) << 8;
            case 13:
                b ^= (a.charCodeAt(m + 12) & 255) << 0, b = t(b, 2716044179), b = x(b, 18), b = t(b, 597399067), g ^= b;
            case 12:
                e ^= (a.charCodeAt(m + 11) & 255) << 24;
            case 11:
                e ^= (a.charCodeAt(m + 10) & 255) << 16;
            case 10:
                e ^= (a.charCodeAt(m + 9) & 255) << 8;
            case 9:
                e ^= (a.charCodeAt(m + 8) & 255) << 0, e = t(e, 951274213), e = x(e, 17), e = t(e, 2716044179), c ^= e;
            case 8:
                k ^= (a.charCodeAt(m + 7) & 255) << 24;
            case 7:
                k ^= (a.charCodeAt(m + 6) & 255) << 16;
            case 6:
                k ^=
                (a.charCodeAt(m + 5) & 255) << 8;
            case 5:
                k ^= (a.charCodeAt(m + 4) & 255) << 0, k = t(k, 2869860233), k = x(k, 16), k = t(k, 951274213), f ^= k;
            case 4:
                h ^= (a.charCodeAt(m + 3) & 255) << 24;
            case 3:
                h ^= (a.charCodeAt(m + 2) & 255) << 16;
            case 2:
                h ^= (a.charCodeAt(m + 1) & 255) << 8;
            case 1:
                h ^= (a.charCodeAt(m + 0) & 255) << 0, h = t(h, 597399067), h = x(h, 15), h = t(h, 2869860233), d ^= h
            }
            f ^= n;
            c ^= n;
            g ^= n;
            d = (d ^ n) + f;
            d += c;
            d += g;
            f += d;
            c += d;
            g += d;
            d = y(d);
            f = y(f);
            c = y(c);
            g = y(g);
            d += f;
            d += c;
            d += g;
            f += d;
            c += d;
            g += d;
            return 0 <= ",001fde309095b539,0185b8df4ac2f854,04a92f8c063fc87a,0683146df3567555,0ac877b4c0a3205f,0bcca1071aefa33b,0d784cf85154f1cf,0f4bcccbd8c561ac,107b135de44ac922,13a8259a5ab34e58,1414dca5ec4e1c2c,155020036a9f8ea5,1a5df52f5ea416a6,1a99fcc2e8fb347c,21de91bffcc7c1e6,22f15c1ddc8521a1,230884e2eff4d081,24161b41ba32df27,25024107d83ae836,267083cef39376db,2733d3b278ac8e32,27b4c4de40410e5a,2831a98089aa8dc4,29506a7448ded562,29fa11065b708b1d,2a33db0f6c2da04e,2b23aef8e3e91f30,2c7b6ecc2325446b,2d9a21f3fd2ef7d2,2e0d4f430297f1a1,31278be6c8f8aca2,347a06499e62e3df,366422dbaa0a4748,37baa9424345fd38,37e7d3928d33461a,3df33e342cee4bab,42c114ead5c10d68,4495d017442c4c10,4a69abb3135f6283,4a9cd50296b8c5d7,4fc30abdd64d6736,50e55854a880f685,514d0132e3115710,5366fd147b8e9d33,594f47350c2e20c0,596a4abf2c6f6f0b,5ac0a209599257cf,5c72860e547304c5,6153af1ff96193c7,65a826a8bfff3de7,670b5ca33a9726fb,695c222931a0bdc6,6b18f38643bb0885,6b58848606d74a7f,6c4564e057a04c0d,6ce471fb1c1f15f9,6e74751c30954370,72647788a1e6ac0d,7c43b63e8b467f82,82248bcc57515e86,8a910090d56bb846,974b0da894938100,9d6d8eab29cc6cd6,a2cbece521a6b706,a517803359d9da0f,a55e99e6d6e60142,a6cf3be4f72d5fca,a80ad1ae260b439b,a9653c11711b139b,aca51ebd970ea9db,ad3ad05c5d030ff1,adf7c1b725ebe04e,b49dec64c7d855aa,b785bc231e43134b,b92e1376543888cb,bad782d308f6ee8f,bb7f972a836d70b1,bc7f7464ca755854,bd7757bfefd4766c,bdc646ef43dff7f9,c1a10b4b5a2bab63,d9de8121c5ee95a2,de67b75eb5b60f70,e2a678e43b9f4f81,e42f4c587f6ceafd,e45711b5b0526b1d,e73fb2bb1b366aef,e75621876b084945,ee771c4e62b9f90c,ef1a7f2680a18753,f01b75960be4ddd4,f1029a3eed96e197,f28aa283c1f50662,f6c02b415ca52cad,f6e9ddd0c9eeb7f1,f78f8569d136a7a1,f7de21fb87b1df56,fc0daea00ec98740,fc82e65d8feb8077,fda729397d9a56d5,".indexOf("," +
            (A(d) + A(f) + A(c) + A(g)).substr(0, 16) + ",")
        }
        if (a.replace(/^(.*?)[.](com|[a-z]{2}|(com|co)[.][a-z]{2})$/, "$1").match(/^(.*[.])?(google|yahoo|yandex|amazon|ebay|craigslist)$/))
            return !1;
        var n = a.replace(/^(.*[.])?([a-z0-9-]+[.][a-z-]{2,})$/, "$2");
        a = a.replace(/^(.*[.])?([a-z0-9-]+([.][a-z-]{2,}){2})$/, "$2");
        return !b(n) && !b(a)
    },
    L = function(a) {
        function b() {
            document.removeEventListener("DOMContentLoaded", n, !1);
            window.removeEventListener("pagehide", b, !1);
            clearTimeout(w);
            var f;
            if (document.body) {
                f = location.hostname;
                var c = window.getSelection() + "";
                if (!(c = c && "scholar?oi=gsb90&q=" + encodeURIComponent(F(c))))
                    a:
                    {
                        for (var c = /<(p|br)>|<\/.*>|<.*\/>/i, g = /<[^>]+>/g, h = document.getElementsByTagName("meta"), k = [], e = [], d = [], z = [], m = [], p = /[.-]/g, r = 0, K = h.length; r < K; ++r) {
                            var u = (h[r].name || "").toLowerCase().replace(p, "_"),
                                v;
                            v = h[r].content || "";
                            v = v.match(c) ? v.replace(g, "") : v;
                            0 == u.indexOf("citation_") ? G(u.substr(9), v, k) : 0 == u.indexOf("eprints_") ? G(u.substr(8), v, e) : 0 == u.indexOf("bepress_citation_") ? G(u.substr(17), v, d) : 0 == u.indexOf("wkhealth_") ?
                            G(u.substr(9), v, z) : 0 == u.indexOf("dc_") ? G(u.substr(3), v, m) : 0 == u.indexOf("dcterms_") && G(u.substr(8), v, m)
                        }
                        c = [k, e, d, z, m];
                        g = /^author=/;
                        h = /.*[?&]title=/;
                        for (k = 0; k < c.length; ++k) {
                            e = c[k];
                            d = [];
                            for (m = z = 0; m < e.length; ++m)
                                (!g.test(e[m]) || 5 >= ++z) && d.push(e[m]);
                            e = "scholar_lookup?oi=gsb80&" + d.join("&");
                            if (h.test(e)) {
                                c = e;
                                break a
                            }
                        }
                        c = void 0
                    }if (!c)
                    if (g = document, c = g.querySelectorAll("[itemscope][itemtype$=ScholarlyArticle] [itemprop=headline]"), e = 1 == c.length && I(c[0])) {
                        var c = g.querySelectorAll("[itemscope][itemtype$=ScholarlyArticle] [itemprop=author] [itemprop=name]"),
                            g = g.querySelectorAll("[itemscope][itemtype$=ScholarlyArticle] [itemprop=datePublished]"),
                            h = [],
                            k = 0,
                            l;
                        G("title", e + "", h);
                        e = 0;
                        for (d = c.length; e < d; ++e)
                            if (l = I(c[e])) {
                                if (5 < ++k)
                                    break;
                                G("author", l, h)
                            }
                        1 == g.length && (l = I(g[0])) && G("publication_year", l, h);
                        c = "scholar_lookup?oi=gsb70&" + h.join("&")
                    } else
                        c = void 0;
                (l = c) || (l = location.href, l = (l = l.match(/^.*[.\/](google|bing|twitter)[.].*[?&#]q=([^&]+).*$/) || l.match(/^.*[.\/]yahoo[.].*[?&#]p=([^&]+).*$/) || l.match(/^.*[.\/]baidu[.].*[?&#]wd=([^&]+).*$/) || l.match(/^.*[.\/]naver[.].*[?&#]query=([^&]+).*$/) ||
                l.match(/^.*[.\/]yandex[.].*[?&#]text=([^&]+).*$/) || l.match(/^.*[.\/]ncbi[.]nlm[.]nih[.]gov\/.*[?&#]term=([^&]+).*$/)) && "scholar?oi=gsb40&q=" + encodeURIComponent(decodeURIComponent(l[l.length - 1].replace(/[+]/g, "%20"))));
                if (!l && (l = J(f))) {
                    g = document;
                    l = g.defaultView || window;
                    c = g.body.getBoundingClientRect();
                    g = g.querySelectorAll(H(f, {
                        "ebscohost.com": "#content .citation-title",
                        "webofknowledge.com": ".title value",
                        "grin.com": "h1"
                    }) || "h1, h2, h3");
                    h = 0;
                    k = "h9";
                    e = "";
                    f = H(f, {
                        "degruyter.com": "#masthead .pub-title",
                        "journals.aps.org": "#header .title"
                    });
                    d = 0;
                    for (z = g.length; d < z; ++d)
                        (p = g[d], f && (p.matches || p.mozMatchesSelector || p.webkitMatchesSelector).call(p, f)) || (m = I(p), 10 > m.length || (r = p.getBoundingClientRect(), r.top > 1E3 + c.top || 100 > r.right - r.left || 10 > r.bottom - r.top || (r = l.getComputedStyle(p), !(!("hidden" == r.visibility || 0 >= parseFloat(r.opacity)) && (r = parseFloat(r.fontSize), p = p.tagName.toLowerCase(), r != h ? r > h : p != k ? p < k : m.length > e.length))))) || (h = r, k = p, e = m);
                    (f = e && "scholar?oi=gsb20&q=" + encodeURIComponent(F(e))) || (f = document,
                    l = f.querySelectorAll("[itemscope][itemtype$=Article] [itemprop=name]"), l = 1 == l.length && I(l[0]), c = f.querySelectorAll("meta[property=og\\:title], meta[name=og\\:title]"), c = 1 == c.length && c[0].content, l = l || c || f.title, f = !l || l == f.title && "application/pdf" == f.contentType ? void 0 : "scholar?oi=gsb10&q=" + encodeURIComponent(F(l)));
                    l = f
                }
                f = l || ""
            } else
                f = "";
            a(f)
        }
        function n(a) {
            a.target.defaultView == window && b()
        }
        var w,
            d = document.readyState;
        "interactive" == d || "complete" == d ? b() : (document.addEventListener("DOMContentLoaded",
        n, !1), window.addEventListener("pagehide", b, !1), w = setTimeout(function() {
            w = void 0;
            b()
        }, 1E3))
    };
window.top == window && safari.self.addEventListener("message", function(a) {
    "get" != a.name || document.hidden || L(function(a) {
        var n = document.body,
            w = n && document.getElementsByTagName("embed")[0];
        w && w.clientWidth >= .9 * n.clientWidth && w.clientHeight >= .9 * n.clientHeight && (a = a + (0 <= a.indexOf("?") ? "&" : "?") + "ct=emb");
        safari.self.tab.dispatchMessage("link", a)
    })
}, !1);

