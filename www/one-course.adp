<master>
  <property name="title">@title@</property>
  <property name="context">"#lors-central.one_course#"</property>

<blockquote>
<table class="list" cellpadding="3" cellspacing="1" width="100%">
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
        #lorsm.Course_Information#
        </th>
    </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Course_Name#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0; font-weight: bold;">
                @course_name;noquote@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Version#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
                  <if @version@ eq "0">
                       @version_msg;noquote@
                  </if>
                  <else>
                       @version;noquote@ Course Versions <a href="course-versions?man_id=@man_id@">Manage</a>
                  </else>
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Metadata#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0">
         	<if @man_metadata@ eq "Yes">
	           <a href="md/pbs-md/?ims_md_id=@man_id@">#lorsm.Yes#</a>
                </if>
	        <else>
                  <a href="md/pbs-md/?ims_md_id=@man_id@">#lorsm.No#</a>
                </else>
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Identifier#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @identifier@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Is_SCORM#
              </td>
              <td 
         	<if @isscorm@ eq "Yes">
	           #lorsm.lt_classlist_stylefont-w#
                </if>
	        <else>
                   class="list"
                </else>
                valign="top" align="left">@isscorm;noquote@
                 </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Storage_Folder#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                <a href="folder-description?folder_id=@folder@">@instance@</a>
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Created_By#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @created_by@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Date#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @creation_date;noquote@
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Submanifests#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                @submanifests@
              </td>
          </tr>
              <tr class="list-even">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lors-central.assoc#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
		  <b>@assoc_num@</b> <a href="one-course-associations?man_id=@man_id@">#lors-central.watch_assoc#</a>
              </td>
          </tr>
              <tr class="list-odd">
              <td class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" width="20%">
                #lorsm.Export#
              </td>
              <td class="list" valign="top" style="background-color: #f0f0f0" width="80%">
                   <a href="export/create-zip?man_id=@man_id@&folder_id=@folder@" title="#lorsm.lt_Export_as_IMS_Content#">[ Zip ]</a>
              </td>
          </tr>
    <tr class="list-header">
        <th class="list" valign="top" style="background-color: #e0e0e0; font-weight: bold;" colspan="2">
         #lorsm.Organizations#
        </th>
    </tr>
              <tr class="list-odd">
              <td  valign="top" style="background-color: #f0f0f0; font-weight: bold;" colspan="2">

              </td>
          </tr>
              <tr class="list-odd">
              <td  valign="top" style="background-color: #f0f0f0; font-weight: bold;" colspan="2">
          @orgs_list;noquote@
              </td>
          </tr>
</table>
</blockquote>

<hr>


