
typedef NSNumber JRString;  /**< TODO */
typedef NSNumber JRBoolean; /**< TODO */
typedef NSNumber JRInteger; /**< TODO */
typedef NSNumber JRNumber; /**< TODO */
typedef NSDate   JRDate; /**< TODO */
typedef NSDate   JRDateTime; /**< TODO */
typedef NSString JRIpAddress; /**< TODO */
typedef NSObject JRPassword; /**< TODO */
typedef NSObject JRJsonObject; /**< TODO */
typedef NSArray  JRArray; /**< TODO */
typedef NSArray  JRStringArray; /**< TODO */
typedef NSString JRUuid; /**< TODO */
typedef NSNumber JRObjectId; /**< TODO */



/**
 * @page Types
 * Capture and Objective-C Types
 *
@anchor types
@htmlonly
<table border="1px solid black">
<tr><b><td>Schema Type  </td><td>Json Type         </td><td>Obj-C Type   </td><td>JRCapture Type            </td><td>Recursive  </td><td>Typedeffed  </td><td>Can Change  </td><td>Notes  </td></b></tr>
<tr><td>string          </td><td>String            </td><td>NSString     </td><td>NSString                  </td><td>           </td><td>No          </td><td>            </td><td>       </td></tr>
<tr><td>boolean         </td><td>Boolean           </td><td>NSNumber     </td><td>JRBoolean                 </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>integer         </td><td>Number            </td><td>NSNumber     </td><td>JRInteger                 </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>decimal         </td><td>Number            </td><td>NSNumber     </td><td>NSNumber                  </td><td>           </td><td>No          </td><td>            </td><td>       </td></tr>
<tr><td>date            </td><td>String            </td><td>NSDate       </td><td>JRDate                    </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>dateTime        </td><td>String            </td><td>NSDate       </td><td>JRDateTime                </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>ipAddress       </td><td>String            </td><td>NSString     </td><td>JRIpAddress               </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>password        </td><td>String or Object  </td><td>NSObject     </td><td>JRPassword                </td><td>           </td><td>Yes         </td><td>            </td><td>       </td></tr>
<tr><td>JSON            </td><td>(any type)        </td><td>NSObject     </td><td>JRJsonObject              </td><td>           </td><td>Yes         </td><td>            </td><td>The JSON type is unstructured data; it only has to be valid parseable JSON.</td></tr>
<tr><td>plural          </td><td>Array             </td><td>NSArray      </td><td>NSArray or JRSimpleArray  </td><td>Yes        </td><td>No/Yes      </td><td>            </td><td>Primitive child attributes of plurals may have the constraint locally-unique.</td></tr>
<tr><td>object          </td><td>Object            </td><td>NSObject     </td><td>JR<PropertyName           </td><td>Yes        </td><td>No          </td><td>            </td><td>       </td></tr>
<tr><td>uuid            </td><td>String            </td><td>NSString     </td><td>JRUuid                    </td><td>           </td><td>Yes         </td><td>            </td><td>Not an externally usable type.</td></tr>
<tr><td>id              </td><td>Number            </td><td>NSNumber     </td><td>JRObjectId                </td><td>           </td><td>Yes         </td><td>            </td><td>Not an externally usable type.</td></tr>
</table>
@endhtmlonly
 *
 **/

