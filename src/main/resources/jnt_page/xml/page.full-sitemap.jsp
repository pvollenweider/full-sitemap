<%@ page contentType="text/xml;UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <c:set target="${renderContext}" property="contentType" value="text/xml;charset=UTF-8" />
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
                <%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
                    <%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
                        <%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
                            <?xml version="1.0" encoding="UTF-8"?>
                            <urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
                                <c:if test="${pageContext.request.serverPort != 80 || pageContext.request.serverPort != 443}">
                                    <c:set var="serverUrl" value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}" />
                                </c:if>
                                <c:if test="${pageContext.request.serverPort == 80 || pageContext.request.serverPort == 443}">
                                    <c:set var="serverUrl" value="${pageContext.request.scheme}://${pageContext.request.serverName}" />
                                </c:if>
                                <jcr:jqom var="contentTemplates">
                                    <query:selector nodeTypeName="jnt:contentTemplate" selectorName="stmp" />
                                </jcr:jqom>
                                <c:set var="contentTypesToHandle" value=" jnt:page" />
                                <c:forEach items="${contentTemplates.nodes}" var="contentTemplate">
                                    <c:forEach items="${contentTemplate.properties['j:applyOn']}" var="applyOn">
                                        <c:set var="currentType" value="${applyOn.string}" />
                                        <c:if test="${! fn:contains(contentTypesToHandle, currentType)}">
                                            <c:set var="contentTypesToHandle" value="${contentTypesToHandle} ${currentType}" />
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:content ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:contentFolder ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:file ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:folder ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:globalSettings ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:nodeType ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:user ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:vfsMountPointFactoryPage ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'jnt:virtualsite ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'wemnt:optimizationTest ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'wemnt:personalizedContent ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'fcnt:form ', '')}" />
                                <c:set var="contentTypesToHandle" value="${fn:replace(contentTypesToHandle, 'fcnt:formFactory ', '')}" />

                                <c:set var="contentTypesToHandle" value="${contentTypesToHandle} jnt:page" />
                                <c:set var="allId" />

                                <c:forEach items="${fn:split(contentTypesToHandle,' ')}" var="contentType">
                                    <c:set var="nodeTyleName" value="${fn:trim(contentType)}" />
                                    <c:catch var="queryException">
                                        <jcr:jqom var="fullList">
                                            <query:selector nodeTypeName="${nodeTyleName}" selectorName="stmp" />
                                            <query:descendantNode path="${renderContext.site.path}" selectorName="stmp" />
                                        </jcr:jqom>
                                        <c:forEach items="${fullList.nodes}" var="item">
                                            <c:catch var="catchException">
                                                <c:set var="identifier" value="${item.identifier}" />
                                                <c:if test="${! fn:contains(allId, identifier) && ! jcr:isNodeType(item, 'cmix:noindex') && ! jcr:isNodeType(item, 'jmix:noindex')}">
                                                    <c:set var="allId" value="${allId} ${identifier}" />
                                                    <url>
                                                        <c:url var="url" value="${item.url}" context="/" />
                                                        <loc>${serverUrl}${url}</loc>
                                                        <jcr:nodeProperty node="${item}" name="jcr:lastModified" var="lastModif" />
                                                        <lastmod>
                                                            <fmt:formatDate value="${lastModif.date.time}" pattern="yyyy-MM-dd" />
                                                        </lastmod>
                                                        <c:choose>
                                                            <c:when test="${jcr:isNodeType(item, 'jmix:sitemap')}">
                                                                <c:set var="changefreq" value="${item.properties.changefreq.string}" />
                                                                <c:set var="priority" value="${item.properties.priority.string}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="changefreq" value="monthly" />
                                                                <c:set var="priority" value="0.5" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <changefreq>${changefreq}</changefreq>
                                                        <priority>${priority}</priority>
                                                    </url>
                                                </c:if>
                                            </c:catch>
                                            <c:if test="${catchException != null}">
                                                <p>The exception is : ${catchException} <br /> There is an exception: ${catchException.message}</p>
                                            </c:if>
                                        </c:forEach>
                                    </c:catch>
                                    <c:if test="${queryException != null}">
                                        <p>The exception is : ${queryException} <br /> There is an exception: ${queryException.message}</p>
                                    </c:if>

                                </c:forEach>
                            </urlset>